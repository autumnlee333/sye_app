import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';

/// Provider for the [BookService].
final bookServiceProvider = Provider<BookService>((ref) {
  return BookService();
});

/// A state notifier to manage book search results.
class BookSearchNotifier extends AsyncNotifier<List<BookModel>> {
  @override
  Future<List<BookModel>> build() async {
    return [];
  }

  /// Searches for books based on the given query.
  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final bookService = ref.read(bookServiceProvider);
      return await bookService.searchBooks(query);
    });
  }
}

/// Provider for book search results.
final bookSearchProvider = AsyncNotifierProvider.autoDispose<BookSearchNotifier, List<BookModel>>(
  BookSearchNotifier.new,
);

/// Provider to fetch details for multiple books by their IDs.
final bookDetailsProvider = FutureProvider.family<List<BookModel>, List<String>>((ref, ids) async {
  if (ids.isEmpty) return [];
  final bookService = ref.read(bookServiceProvider);
  final futures = ids.map((id) => bookService.getBookById(id));
  final results = await Future.wait(futures);
  return results.whereType<BookModel>().toList();
});

