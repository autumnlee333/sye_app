import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class BookService {
  final http.Client _client;
  static const String _apiKey = 'AIzaSyDVAYZUuURl6ez3JXSea__Qzs4xLHYCJY4';
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  BookService({http.Client? client}) : _client = client ?? http.Client();

  /// Helper to perform a GET request with automatic retries for temporary failures.
  Future<http.Response> _getWithRetry(Uri url, {int retries = 2}) async {
    for (int i = 0; i <= retries; i++) {
      try {
        final response = await _client.get(url);
        if (response.statusCode == 503 && i < retries) {
          await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
          continue;
        }
        return response;
      } on SocketException {
        if (i == retries) rethrow;
        await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
      } catch (e) {
        if (i == retries) rethrow;
      }
    }
    throw Exception('Failed to connect to book service.');
  }

  /// Searches for books using the Google Books API.
  Future<List<BookModel>> searchBooks(String query) async {
    if (query.isEmpty) return [];

    try {
      final url = Uri.parse('$_baseUrl?q=${Uri.encodeComponent(query)}&maxResults=40&key=$_apiKey');
      final response = await _getWithRetry(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        final books = items.map((item) => _parseBook(item)).toList();
        final queryLower = query.toLowerCase().trim();
        
        books.sort((a, b) {
          // 1. POPULARITY SCORE (Exponential)
          double getPopScore(BookModel book) {
            final count = (book.ratingsCount > 0 ? (math.log(book.ratingsCount) / math.log(1000000)) : 0.0).clamp(0.0, 1.0);
            final rating = (book.averageRating ?? 3.0) / 5.0;
            return math.pow((count * 0.8) + (rating * 0.2), 2.0).toDouble();
          }

          // 2. MATCH QUALITY
          double getMatchQuality(BookModel book) {
            final titleLower = book.title.toLowerCase();
            
            // A. EXACT MATCH (The "Stephen King It" fix)
            if (titleLower == queryLower) return 1.0;
            
            // B. SERIES MATCH (Starts with)
            if (titleLower.startsWith('$queryLower ') || titleLower.startsWith('$queryLower:')) return 0.9;
            
            // C. AUTHOR MATCH
            for (var author in book.authors) {
              if (author.toLowerCase() == queryLower) return 0.8;
            }

            // D. FUZZY / CONTAINS
            final dice = _calculateBestSimilarity(book, queryLower);
            final contains = titleLower.contains(queryLower) ? 0.3 : 0.0;
            return math.max(dice, contains);
          }

          // 3. FINAL SCORE
          // Increase Match Quality weight to 70% to ensure exact titles win over popular side-books
          final scoreA = (getMatchQuality(a) * 0.7) + (getPopScore(a) * 0.3);
          final scoreB = (getMatchQuality(b) * 0.7) + (getPopScore(b) * 0.3);

          return scoreB.compareTo(scoreA);
        });

        return books.take(20).toList();
      }
      throw Exception('Status ${response.statusCode}');
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }

  /// Fetches a single book by its ID.
  Future<BookModel?> getBookById(String id) async {
    try {
      final url = Uri.parse('$_baseUrl/$id?key=$_apiKey');
      final response = await _getWithRetry(url);
      if (response.statusCode == 200) {
        return _parseBook(json.decode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetches book recommendations based on genres.
  Future<List<BookModel>> getRecommendations(List<String> genres) async {
    if (genres.isEmpty) return [];
    final genresToQuery = List<String>.from(genres)..shuffle();
    final activeGenres = genresToQuery.take(5).toList();

    final results = await Future.wait(
      activeGenres.map((genre) async {
        try {
          final url = Uri.parse('$_baseUrl?q=subject:${Uri.encodeComponent(genre)}&orderBy=newest&maxResults=20&key=$_apiKey');
          final response = await _getWithRetry(url);
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final List<dynamic> items = data['items'] ?? [];
            return items.map((item) => _parseBook(item)).toList();
          }
        } catch (_) {}
        return <BookModel>[];
      }),
    );

    final combinedBooks = results.expand((x) => x).toList()..shuffle();
    final seenIds = <String>{};
    return combinedBooks.where((b) => seenIds.add(b.id)).take(20).toList();
  }

  /// Fetches books similar to a list of existing books.
  Future<List<BookModel>> getSimilarBooks(List<BookModel> books) async {
    if (books.isEmpty) return [];
    final shuffledBooks = List<BookModel>.from(books)..shuffle();
    for (final baseBook in shuffledBooks) {
      try {
        List<String> queryParts = [];
        if (baseBook.authors.isNotEmpty) queryParts.add('inauthor:${baseBook.authors.first}');
        if (baseBook.categories.isNotEmpty) queryParts.add('subject:${baseBook.categories.first}');
        if (queryParts.isEmpty) queryParts.add(baseBook.title.split(' ').take(3).join(' '));

        final query = queryParts.join('+');
        final url = Uri.parse('$_baseUrl?q=${Uri.encodeComponent(query)}&maxResults=20&key=$_apiKey');
        final response = await _getWithRetry(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List<dynamic> items = data['items'] ?? [];
          final originalIds = books.map((b) => b.id).toSet();
          final results = items.map((item) => _parseBook(item)).where((book) => !originalIds.contains(book.id)).toList();
          if (results.isNotEmpty) {
            results.shuffle();
            return results.take(15).toList();
          }
        }
      } catch (_) {}
    }
    return [];
  }

  BookModel _parseBook(Map<String, dynamic> item) {
    final volumeInfo = item['volumeInfo'] ?? {};
    final id = item['id'] as String;
    final title = volumeInfo['title'] as String? ?? 'No Title';
    final authors = (volumeInfo['authors'] as List<dynamic>?)?.cast<String>() ?? [];
    final description = _stripHtml(volumeInfo['description'] as String?);
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final thumbnailUrl = (imageLinks['thumbnail'] as String?)?.replaceFirst('http://', 'https://');
    final pageCount = volumeInfo['pageCount'] as int?;
    final averageRating = (volumeInfo['averageRating'] as num?)?.toDouble();
    final ratingsCount = (volumeInfo['ratingsCount'] as int?) ?? 0;
    final categories = (volumeInfo['categories'] as List<dynamic>?)?.cast<String>() ?? [];

    return BookModel(
      id: id,
      title: title,
      authors: authors,
      description: description,
      thumbnailUrl: thumbnailUrl,
      pageCount: pageCount,
      averageRating: averageRating,
      ratingsCount: ratingsCount,
      categories: categories,
    );
  }

  String? _stripHtml(String? html) {
    if (html == null) return null;
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  double _calculateBestSimilarity(BookModel book, String query) {
    double maxScore = _diceCoefficient(book.title.toLowerCase(), query);
    for (final author in book.authors) {
      final authorScore = _diceCoefficient(author.toLowerCase(), query);
      if (authorScore > maxScore) maxScore = authorScore;
    }
    return maxScore;
  }

  double _diceCoefficient(String first, String second) {
    if (first == second) return 1.0;
    if (first.length < 2 || second.length < 2) return 0.0;
    final firstBigrams = <String>{};
    for (var i = 0; i < first.length - 1; i++) {
      firstBigrams.add(first.substring(i, i + 2));
    }
    final secondBigrams = <String>{};
    for (var i = 0; i < second.length - 1; i++) {
      secondBigrams.add(second.substring(i, i + 2));
    }
    final intersection = firstBigrams.intersection(secondBigrams).length;
    return (2.0 * intersection) / (firstBigrams.length + secondBigrams.length);
  }
}
