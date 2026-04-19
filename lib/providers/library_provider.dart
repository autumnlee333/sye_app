import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/library_book_model.dart';
import '../models/book_model.dart';
import '../models/activity_model.dart';
import '../services/library_service.dart';
import 'auth_provider.dart';
import 'activity_provider.dart';
import 'list_provider.dart';

/// Provider for the [LibraryService].
final libraryServiceProvider = Provider<LibraryService>((ref) {
  return LibraryService();
});

/// A simple StateProvider to track the book that was just marked as finished.
final finishedBookProvider = StateProvider<LibraryBookModel?>((ref) => null);

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

/// A provider that filters the user's library by [ReadingStatus].
final libraryProvider = Provider.family<AsyncValue<List<LibraryBookModel>>, ReadingStatus>((ref, status) {
  final libraryAsync = ref.watch(userLibraryProvider);
  
  return libraryAsync.when(
    data: (books) => AsyncValue.data(books.where((b) => b.status == status).toList()),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
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
    
    final finishedBookNotifier = ref.read(finishedBookProvider.notifier);

    state = await AsyncValue.guard(() async {
      final libraryBook = LibraryBookModel(
        bookId: book.id,
        title: book.title,
        authors: book.authors,
        thumbnailUrl: book.thumbnailUrl,
        status: status,
        addedAt: DateTime.now(),
        averageRating: book.averageRating,
        categories: book.categories,
      );
      await ref.read(libraryServiceProvider).addBookToLibrary(user.uid, libraryBook);
      
      // Post activity if they started reading
      if (status == ReadingStatus.reading) {
        await ref.read(activityActionProvider.notifier).postActivity(ActivityModel(
          id: '',
          userId: user.uid,
          userName: '', // Handled by ActivityNotifier
          bookId: book.id,
          bookTitle: book.title,
          bookAuthors: book.authors,
          bookThumbnail: book.thumbnailUrl,
          type: ActivityType.started,
          timestamp: DateTime.now(),
        ));
      }

      if (status == ReadingStatus.finished) {
        finishedBookNotifier.state = libraryBook;
      }
    });
  }

  Future<void> updateStatus(LibraryBookModel book, ReadingStatus status) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    
    final finishedBookNotifier = ref.read(finishedBookProvider.notifier);

    state = await AsyncValue.guard(() async {
      await ref.read(libraryServiceProvider).updateBookStatus(user.uid, book.bookId, status);
      
      if (status == ReadingStatus.finished) {
        finishedBookNotifier.state = book;
      }
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

  Future<void> bulkRemoveBooks(List<String> bookIds) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(libraryServiceProvider).removeBooksFromLibrary(user.uid, bookIds);
    });
  }

  Future<void> bulkUpdateStatus(List<String> bookIds, ReadingStatus status) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(libraryServiceProvider).updateBooksStatus(user.uid, bookIds, status);
    });
  }

  Future<void> updateProgress(
    String bookId, 
    int currentPage, 
    int totalPages, 
    {String? comment, bool postToFeed = false}
  ) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(libraryServiceProvider).updateProgress(
            user.uid,
            bookId,
            currentPage,
            totalPages,
            comment: comment,
          );
      
      if (postToFeed) {
        // Fetch book details from library for activity post
        final library = ref.read(userLibraryProvider).value ?? [];
        final book = library.firstWhere((b) => b.bookId == bookId);

        await ref.read(activityActionProvider.notifier).postActivity(ActivityModel(
          id: '',
          userId: user.uid,
          userName: '', // Handled by ActivityNotifier
          bookId: bookId,
          bookTitle: book.title,
          bookAuthors: book.authors,
          bookThumbnail: book.thumbnailUrl,
          type: ActivityType.progress,
          text: comment,
          page: currentPage,
          totalPages: totalPages,
          timestamp: DateTime.now(),
        ));
      }
    });
  }

  /// Unifies adding a book to either a standard shelf or a custom list.
  Future<void> addBookToAnyShelf({
    required BookModel book,
    ReadingStatus? status,
    String? customListId,
  }) async {
    if (status != null) {
      await addBook(book, status);
    }
    
    if (customListId != null) {
      await ref.read(listActionProvider.notifier).addBookToList(customListId, book.id);
    }
  }
}

final libraryActionProvider = AsyncNotifierProvider<LibraryNotifier, void>(
  LibraryNotifier.new,
);
