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
  final userAsync = ref.watch(currentUserDataProvider);

  // Wait for the user profile to be available
  final userProfile = userAsync.value;
  if (userProfile == null) {
    return Completer<List<BookModel>>().future;
  }

  if (userProfile.favoriteGenres.isEmpty) return [];

  final bookService = ref.read(bookServiceProvider);
  return await bookService.getRecommendations(userProfile.favoriteGenres);
});

/// Provider for "Smart" recommendations based on the user's actual favorite books.
final smartRecommendationsProvider = FutureProvider<List<BookModel>>((ref) async {
  final userAsync = ref.watch(currentUserDataProvider);

  final userProfile = userAsync.value;
  if (userProfile == null) {
    return Completer<List<BookModel>>().future;
  }

  if (userProfile.topFavoriteBookIds.isEmpty) return [];

  final bookService = ref.read(bookServiceProvider);

  // Optimization: Only fetch details for up to 3 favorites to speed up similarity search
  final favoriteIds = List<String>.from(userProfile.topFavoriteBookIds)..shuffle();
  final subsetIds = favoriteIds.take(3).toList();

  final favoriteBooks = await ref.watch(bookDetailsProvider(subsetIds).future);

  // Then get similar books based on those favorites
  return await bookService.getSimilarBooks(favoriteBooks);
});

