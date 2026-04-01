import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/library_book_model.dart';
import '../providers/library_provider.dart';
import '../providers/review_provider.dart';
import '../widgets/book_card.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryAsync = ref.watch(userLibraryProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Library'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Reading'),
              Tab(text: 'Want to Read'),
              Tab(text: 'Finished'),
            ],
          ),
        ),
        body: libraryAsync.when(
          data: (books) {
            if (books.isEmpty) {
              return const Center(
                child: Text('Your library is empty. Start adding books!'),
              );
            }

            final reading = books.where((b) => b.status == ReadingStatus.reading).toList();
            final wantToRead = books.where((b) => b.status == ReadingStatus.wantToRead).toList();
            final finished = books.where((b) => b.status == ReadingStatus.finished).toList();

            return TabBarView(
              children: [
                _BookList(books: reading, emptyMessage: 'Not reading anything yet.'),
                _BookList(books: wantToRead, emptyMessage: 'No books on your wishlist.'),
                _BookList(books: finished, emptyMessage: 'No books finished yet.'),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading library: $e')),
        ),
      ),
    );
  }
}

class _BookList extends ConsumerWidget {
  final List<LibraryBookModel> books;
  final String emptyMessage;

  const _BookList({required this.books, required this.emptyMessage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (books.isEmpty) {
      return Center(child: Text(emptyMessage, style: const TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final libraryBook = books[index];
        return Column(
          children: [
            BookCard(
              title: libraryBook.title,
              authors: libraryBook.authors,
              thumbnailUrl: libraryBook.thumbnailUrl,
              onTap: libraryBook.status == ReadingStatus.reading 
                ? () => _showUpdateProgressDialog(context, ref, libraryBook)
                : null,
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'review') {
                    _showReviewDialog(context, ref, libraryBook);
                  } else {
                    final status = ReadingStatus.values.firstWhere((e) => e.name == value);
                    ref.read(libraryActionProvider.notifier).updateStatus(libraryBook.bookId, status);
                  }
                },
                itemBuilder: (context) => [
                  ...ReadingStatus.values.map((status) {
                    return PopupMenuItem(
                      value: status.name,
                      child: Text(status.label),
                    );
                  }),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'review',
                    child: Text('Rate & Review', style: TextStyle(color: Colors.blue)),
                  ),
                  PopupMenuItem(
                    onTap: () => ref.read(libraryActionProvider.notifier).removeBook(libraryBook.bookId),
                    child: const Text('Remove from Library', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
            if (libraryBook.status == ReadingStatus.reading && libraryBook.totalPages > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: libraryBook.currentPage / libraryBook.totalPages,
                      backgroundColor: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${((libraryBook.currentPage / libraryBook.totalPages) * 100).toInt()}% complete',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          'Page ${libraryBook.currentPage} of ${libraryBook.totalPages}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  void _showReviewDialog(BuildContext context, WidgetRef ref, LibraryBookModel book) {
    double rating = 0;
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Review: ${book.title}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('What do you think?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => setState(() => rating = index + 1.0),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write your thoughts here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: rating == 0 ? null : () {
                ref.read(reviewActionProvider.notifier).postReview(
                  bookId: book.bookId,
                  bookTitle: book.title,
                  bookAuthors: book.authors,
                  bookThumbnail: book.thumbnailUrl,
                  rating: rating,
                  text: reviewController.text.trim(),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Review posted!')),
                );
              },
              child: const Text('Post Review'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateProgressDialog(BuildContext context, WidgetRef ref, LibraryBookModel book) {
    final pageController = TextEditingController(text: book.currentPage.toString());
    final totalController = TextEditingController(text: book.totalPages.toString());
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Progress: ${book.title}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Current Page'),
              ),
              TextField(
                controller: totalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Total Pages'),
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(labelText: 'Comment (Optional)'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final currentPage = int.tryParse(pageController.text) ?? 0;
              final totalPages = int.tryParse(totalController.text) ?? 0;
              
              ref.read(libraryActionProvider.notifier).updateProgress(
                book.bookId,
                currentPage,
                totalPages,
                comment: commentController.text.trim().isEmpty ? null : commentController.text.trim(),
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
