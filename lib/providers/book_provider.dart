import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import 'user_provider.dart';

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
final bookSearchProvider = AsyncNotifierProvider<BookSearchNotifier, List<BookModel>>(
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

/// Provider to fetch a single book by its ID.
final singleBookProvider = FutureProvider.family<BookModel?, String>((ref, id) async {
  return await ref.read(bookServiceProvider).getBookById(id);
});

/// Provider for recommended books based on user's favorite genres.
final recommendationsProvider = FutureProvider<List<BookModel>>((ref) async {
  // Use the future property of the provider to await data correctly
  final userProfile = await ref.watch(currentUserDataProvider.future);
  if (userProfile == null || userProfile.favoriteGenres.isEmpty) return [];

  final bookService = ref.read(bookServiceProvider);
  return await bookService.getRecommendations(userProfile.favoriteGenres);
});

/// Provider for "Smart" recommendations based on the user's actual favorite books.
final smartRecommendationsProvider = FutureProvider<List<BookModel>>((ref) async {
  // Use the future property of the provider to await data correctly
  final userProfile = await ref.watch(currentUserDataProvider.future);
  if (userProfile == null || userProfile.topFavoriteBookIds.isEmpty) return [];

  final bookService = ref.read(bookServiceProvider);

  // Fetch details for ALL favorite books to give the similarity engine more to work with
  final favoriteBooks = await ref.watch(bookDetailsProvider(userProfile.topFavoriteBookIds).future);

  // Then get similar books based on those favorites
  return await bookService.getSimilarBooks(favoriteBooks);
});

