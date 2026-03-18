import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class BookService {
  final http.Client _client;

  BookService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  /// Searches for books using the Google Books API.
  Future<List<BookModel>> searchBooks(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl?q=${Uri.encodeComponent(query)}&maxResults=20'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        return items.map((item) => _parseBook(item)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }

  /// Parses a single book item from the Google Books API response.
  BookModel _parseBook(Map<String, dynamic> item) {
    final volumeInfo = item['volumeInfo'] ?? {};
    final id = item['id'] as String;
    final title = volumeInfo['title'] as String? ?? 'No Title';
    final authors = (volumeInfo['authors'] as List<dynamic>?)?.cast<String>() ?? [];
    final description = volumeInfo['description'] as String?;
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
}
