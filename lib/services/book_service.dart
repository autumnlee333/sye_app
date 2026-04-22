import 'dart:convert';
import 'dart:io';
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
          // Google Books API sometimes returns 503 when overloaded. Wait and retry.
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

        // Advanced Search Logic: Re-rank books based on fuzzy matching
        final queryLower = query.toLowerCase();
        
        books.sort((a, b) {
          final scoreA = _calculateBestSimilarity(a, queryLower);
          final scoreB = _calculateBestSimilarity(b, queryLower);
          return scoreB.compareTo(scoreA);
        });

        return books.take(20).toList();
      } else if (response.statusCode == 429) {
        throw Exception('Too many requests. Please wait a moment.');
      } else if (response.statusCode == 503) {
        throw Exception('Book service is temporarily unavailable. Please try again in a few seconds.');
      } else {
        throw Exception('Failure to load books: ${response.statusCode}');
      }
    } catch (e) {
      // If it's already an Exception with our custom message, just rethrow it
      if (e.toString().contains('Exception:')) rethrow;
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

    final shuffledGenres = List<String>.from(genres)..shuffle();
    final genresToTry = shuffledGenres.take(3).toList();

    // Fetch multiple genres in parallel for speed
    final results = await Future.wait(
      genresToTry.map((genre) async {
        try {
          final url = Uri.parse('$_baseUrl?q=subject:${Uri.encodeComponent(genre)}&orderBy=relevance&maxResults=10&key=$_apiKey');
          final response = await _getWithRetry(url);

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final List<dynamic> items = data['items'] ?? [];
            return items.map((item) => _parseBook(item)).toList();
          }
        } catch (_) {
          // Individual genre failure is fine if others succeed
        }
        return <BookModel>[];
      }),
    );

    // Return the first non-empty result
    for (final result in results) {
      if (result.isNotEmpty) return result;
    }

    throw Exception('Failed to load recommendations. Please check your connection.');
  }

  /// Fetches books similar to a list of existing books.
  Future<List<BookModel>> getSimilarBooks(List<BookModel> books) async {
    if (books.isEmpty) return [];

    try {
      final baseBook = (List<BookModel>.from(books)..shuffle()).first;
      
      String query = '';
      if (baseBook.authors.isNotEmpty) {
        query += 'inauthor:${baseBook.authors.first}';
      }
      if (baseBook.categories.isNotEmpty) {
        if (query.isNotEmpty) query += '+';
        query += 'subject:${baseBook.categories.first}';
      } else {
        final titleWords = baseBook.title.split(' ').take(2).join(' ');
        if (query.isNotEmpty) query += '+';
        query += titleWords;
      }

      final url = Uri.parse('$_baseUrl?q=${Uri.encodeComponent(query)}&maxResults=10&key=$_apiKey');
      final response = await _getWithRetry(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];
        
        final originalIds = books.map((b) => b.id).toSet();
        return items
            .map((item) => _parseBook(item))
            .where((book) => !originalIds.contains(book.id))
            .toList();
      }
      throw Exception('Status ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load similar books.');
    }
  }

  /// Parses a single book item from the Google Books API response.
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
    final categories = (volumeInfo['categories'] as List<dynamic>?)?.cast<String>() ?? [];

    return BookModel(
      id: id,
      title: title,
      authors: authors,
      description: description,
      thumbnailUrl: thumbnailUrl,
      pageCount: pageCount,
      averageRating: averageRating,
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
