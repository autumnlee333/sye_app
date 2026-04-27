
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/library_book_model.dart';
import 'library_provider.dart';

/// A class to hold the calculated statistics for the dashboard.
class ReadingStats {
  final Map<int, int> booksPerMonth; // Month (1-12) -> Count
  final Map<String, int> genreBreakdown; // Genre -> Count
  final int totalBooksFinished;
  final int totalPagesRead;
  final List<MonthlyPages> pagesPerMonth;

  ReadingStats({
    required this.booksPerMonth,
    required this.genreBreakdown,
    required this.totalBooksFinished,
    required this.totalPagesRead,
    required this.pagesPerMonth,
  });
}

class MonthlyPages {
  final int month;
  final int pages;
  MonthlyPages(this.month, this.pages);
}

/// Provider that processes the library data into dashboard-ready statistics.
final readingStatsProvider = Provider<AsyncValue<ReadingStats>>((ref) {
  final libraryAsync = ref.watch(userLibraryProvider);

  return libraryAsync.when(
    data: (library) {
      final finishedBooks = library.where((b) => b.status == ReadingStatus.finished).toList();
      final currentYear = DateTime.now().year;
      
      // 1. Books per Month (Current Year)
      final booksPerMonth = <int, int>{};
      for (int i = 1; i <= 12; i++) booksPerMonth[i] = 0;
      
      for (var book in finishedBooks) {
        final date = book.completedAt ?? book.addedAt;
        if (date.year == currentYear) {
          booksPerMonth[date.month] = (booksPerMonth[date.month] ?? 0) + 1;
        }
      }

      // 2. Genre Breakdown
      final genreBreakdown = <String, int>{};
      for (var book in finishedBooks) {
        for (var genre in book.categories) {
          genreBreakdown[genre] = (genreBreakdown[genre] ?? 0) + 1;
        }
      }

      // 3. Total Stats
      int totalPages = 0;
      for (var book in finishedBooks) {
        totalPages += book.totalPages;
      }

      // 4. Page count trends (Current Year)
      final pagesMap = <int, int>{};
      for (int i = 1; i <= 12; i++) pagesMap[i] = 0;
      
      for (var book in finishedBooks) {
        final date = book.completedAt ?? book.addedAt;
        if (date.year == currentYear) {
          pagesMap[date.month] = (pagesMap[date.month] ?? 0) + book.totalPages;
        }
      }
      
      final pagesPerMonth = pagesMap.entries
          .map((e) => MonthlyPages(e.key, e.value))
          .toList()
        ..sort((a, b) => a.month.compareTo(b.month));

      return AsyncValue.data(ReadingStats(
        booksPerMonth: booksPerMonth,
        genreBreakdown: genreBreakdown,
        totalBooksFinished: finishedBooks.length,
        totalPagesRead: totalPages,
        pagesPerMonth: pagesPerMonth,
      ));
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});
