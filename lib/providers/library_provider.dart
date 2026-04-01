import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/library_book_model.dart';
import '../models/book_model.dart';
import '../services/library_service.dart';
import 'auth_provider.dart';

/// Provider for the [LibraryService].
final libraryServiceProvider = Provider<LibraryService>((ref) {
  return LibraryService();
});

/// A stream provider that watches the current user's library.
final userLibraryProvider = StreamProvider<List<LibraryBookModel>>((ref) {
  final authState = ref.watch(authProvider);
  final libraryService = ref.watch(libraryServiceProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      return libraryService.watchLibrary(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, _) => Stream.value([]),
  );
});

/// A notifier to manage library operations.
class LibraryNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addBook(BookModel book, ReadingStatus status) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final libraryBook = LibraryBookModel(
        bookId: book.id,
        title: book.title,
        authors: book.authors,
        thumbnailUrl: book.thumbnailUrl,
        status: status,
        addedAt: DateTime.now(),
      );
      await ref.read(libraryServiceProvider).addBookToLibrary(user.uid, libraryBook);
    });
  }

  Future<void> updateStatus(String bookId, ReadingStatus status) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(libraryServiceProvider).updateBookStatus(user.uid, bookId, status);
    });
  }

  Future<void> removeBook(String bookId) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(libraryServiceProvider).removeBookFromLibrary(user.uid, bookId);
    });
  }
}

final libraryActionProvider = AsyncNotifierProvider.autoDispose<LibraryNotifier, void>(
  LibraryNotifier.new,
);
