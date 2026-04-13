import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/library_book_model.dart';
import '../providers/library_provider.dart';
import '../providers/review_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/review_dialog.dart';
import 'book_details_screen.dart';

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
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
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
                _BookList(
                  books: reading,
                  emptyMessage: 'Not reading anything yet.',
                ),
                _BookList(
                  books: wantToRead,
                  emptyMessage: 'No books on your wishlist.',
                ),
                _BookList(
                  books: finished,
                  emptyMessage: 'No books finished yet.',
                ),
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

  const _BookList({
    required this.books,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (books.isEmpty) {
      return Center(child: Text(emptyMessage, style: const TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final libraryBook = books[index];
        final userReviewAsync = ref.watch(userReviewForBookProvider(libraryBook.bookId));

        return Column(
          children: [
            BookCard(
              title: libraryBook.title,
              authors: libraryBook.authors,
              thumbnailUrl: libraryBook.thumbnailUrl,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BookDetailsScreen(
                      bookId: libraryBook.bookId,
                    ),
                  ),
                );
              },
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'review') {
                    final existingReview = userReviewAsync.value;
                    ReviewDialog.show(
                      context, 
                      libraryBook,
                      id: existingReview?.id,
                      initialRating: existingReview?.rating,
                      initialText: existingReview?.reviewText,
                      activityId: existingReview?.activityId,
                    );
                  } else {
                    try {
                      final status = ReadingStatus.values.firstWhere((e) => e.name == value);
                      debugPrint('Updating status for ${libraryBook.title} to $status');
                      
                      await ref.read(libraryActionProvider.notifier).updateStatus(libraryBook, status);
                    } catch (e) {
                      debugPrint('Error updating status: $e');
                    }
                  }
                },
                itemBuilder: (context) {
                  final hasReview = userReviewAsync.value != null;
                  return [
                    ...ReadingStatus.values.map((status) {
                      return PopupMenuItem(
                        value: status.name,
                        child: Text(status.label),
                      );
                    }),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'review',
                      child: Text(
                        hasReview ? 'Edit Review' : 'Rate & Review', 
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => ref.read(libraryActionProvider.notifier).removeBook(libraryBook.bookId),
                      child: const Text('Remove from Library', style: TextStyle(color: Colors.red)),
                    ),
                  ];
                },
              ),
            ),
            if (libraryBook.status == ReadingStatus.reading) ...[
              if (libraryBook.totalPages > 0)
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.edit_note, size: 18),
                        label: const Text('Update Progress'),
                        onPressed: () => _showUpdateProgressDialog(context, ref, libraryBook),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.send, size: 18),
                        label: const Text('Post Thought'),
                        onPressed: () => _showUpdateProgressDialog(context, ref, libraryBook, forcePost: true),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }

  void _showUpdateProgressDialog(BuildContext context, WidgetRef ref, LibraryBookModel book, {bool forcePost = false}) {
    final pageController = TextEditingController(text: book.currentPage.toString());
    final totalController = TextEditingController(text: book.totalPages.toString());
    final commentController = TextEditingController();
    bool postToFeed = forcePost;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(forcePost ? 'Post a Thought' : 'Update Progress'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: pageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Current Page',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: totalController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Total Pages',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    labelText: 'What are your thoughts?',
                    hintText: 'Share a quick update with your friends...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                if (!forcePost)
                  CheckboxListTile(
                    title: const Text('Post to Live Board', style: TextStyle(fontSize: 14)),
                    value: postToFeed,
                    onChanged: (value) => setState(() => postToFeed = value ?? false),
                    contentPadding: EdgeInsets.zero,
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
                  postToFeed: postToFeed,
                );
                Navigator.pop(context);
                
                if (postToFeed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thought posted to feed!')),
                  );
                }
              },
              child: Text(forcePost ? 'Post' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
.
