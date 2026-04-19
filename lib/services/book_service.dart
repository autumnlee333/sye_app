import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class BookService {
  final http.Client _client;
  static const String _apiKey = 'AIzaSyDVAYZUuURl6ez3JXSea__Qzs4xLHYCJY4';
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  BookService({http.Client? client}) : _client = client ?? http.Client();

  /// Searches for books using the Google Books API.
  Future<List<BookModel>> searchBooks(String query) async {
    if (query.isEmpty) return [];

    try {
      // Increase maxResults to 40 to have a larger pool for fuzzy re-ranking
      final url = Uri.parse('$_baseUrl?q=${Uri.encodeComponent(query)}&maxResults=40&key=$_apiKey');
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        final books = items.map((item) => _parseBook(item)).toList();

        // Advanced Search Logic: Re-rank books based on fuzzy matching
        // This helps handle typos by prioritizing books whose titles or authors 
        // most closely match the query.
        final queryLower = query.toLowerCase();
        
        books.sort((a, b) {
          final scoreA = _calculateBestSimilarity(a, queryLower);
          final scoreB = _calculateBestSimilarity(b, queryLower);
          return scoreB.compareTo(scoreA); // Higher similarity score first
        });

        // Return the top 20 most relevant results
        return books.take(20).toList();
      } else if (response.statusCode == 429) {
        throw Exception('Too many requests. Please wait a moment.');
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }

  /// Fetches a single book by its ID.
  Future<BookModel?> getBookById(String id) async {
    try {
      final url = Uri.parse('$_baseUrl/$id?key=$_apiKey');
      final response = await _client.get(url);
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

    try {
      // Pick a random genre from the user's favorites to keep the recommendations fresh
      final genre = (List<String>.from(genres)..shuffle()).first;
      final url = Uri.parse('$_baseUrl?q=subject:${Uri.encodeComponent(genre)}&orderBy=relevance&maxResults=10&key=$_apiKey');
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];
        return items.map((item) => _parseBook(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Fetches books similar to a list of existing books (based on authors or themes).
  Future<List<BookModel>> getSimilarBooks(List<BookModel> books) async {
    if (books.isEmpty) return [];

    try {
      // Pick a random book from the list to base recommendations on
      final baseBook = (List<BookModel>.from(books)..shuffle()).first;
      
      // Use author + first category/keyword for a "more like this" query
      String query = '';
      if (baseBook.authors.isNotEmpty) {
        query += 'inauthor:${baseBook.authors.first}';
      }
      if (baseBook.categories.isNotEmpty) {
        if (query.isNotEmpty) query += '+';
        query += 'subject:${baseBook.categories.first}';
      } else {
        // Fallback to title keywords if no categories
        final titleWords = baseBook.title.split(' ').take(2).join(' ');
        if (query.isNotEmpty) query += '+';
        query += titleWords;
      }

      final url = Uri.parse('$_baseUrl?q=${Uri.encodeComponent(query)}&maxResults=10&key=$_apiKey');
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];
        
        // Filter out the original books from results
        final originalIds = books.map((b) => b.id).toSet();
        return items
            .map((item) => _parseBook(item))
            .where((book) => !originalIds.contains(book.id))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
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
    // Simple regex to remove HTML tags
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Calculates the best similarity score for a book against a query.
  /// Checks title and authors.
  double _calculateBestSimilarity(BookModel book, String query) {
    double maxScore = _diceCoefficient(book.title.toLowerCase(), query);
    
    for (final author in book.authors) {
      final authorScore = _diceCoefficient(author.toLowerCase(), query);
      if (authorScore > maxScore) maxScore = authorScore;
    }
    
    return maxScore;
  }

  /// Simple string similarity using Sørensen–Dice coefficient.
  /// Returns a value between 0.0 and 1.0.
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
