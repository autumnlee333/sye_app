import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/library_book_model.dart';
import '../providers/library_provider.dart';
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
              trailing: PopupMenuButton<ReadingStatus>(
                onSelected: (status) {
                  ref.read(libraryActionProvider.notifier).updateStatus(libraryBook.bookId, status);
                },
                itemBuilder: (context) => ReadingStatus.values.map((status) {
                  return PopupMenuItem(
                    value: status,
                    child: Text(status.label),
                  );
                }).toList()..add(
                  PopupMenuItem(
                    onTap: () => ref.read(libraryActionProvider.notifier).removeBook(libraryBook.bookId),
                    child: const Text('Remove from Library', style: TextStyle(color: Colors.red)),
                  ) as PopupMenuItem<ReadingStatus>,
                ),
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
