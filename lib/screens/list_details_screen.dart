import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/custom_list_model.dart';
import '../providers/book_provider.dart';
import '../providers/list_provider.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';

class ListDetailsScreen extends ConsumerWidget {
  final CustomListModel list;

  const ListDetailsScreen({super.key, required this.list});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to changes for this specific list from the stream
    final allLists = ref.watch(userListsProvider).value ?? [];
    final currentList = allLists.firstWhere((l) => l.id == list.id, orElse: () => list);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentList.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref, currentList),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (currentList.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                currentList.description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          Expanded(
            child: currentList.bookIds.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No books in this list yet.', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ref.watch(bookDetailsProvider(currentList.bookIds)).when(
                      data: (books) => ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return BookCard(
                            title: book.title,
                            authors: book.authors,
                            thumbnailUrl: book.thumbnailUrl,
                            averageRating: book.averageRating,
                            categories: book.categories,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BookDetailsScreen(
                                    bookId: book.id,
                                    initialBook: book,
                                  ),
                                ),
                              );
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () {
                                ref.read(listActionProvider.notifier).removeBookFromList(currentList.id, book.id);
                              },
                            ),
                          );
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                    ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, CustomListModel list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete List?'),
        content: Text('Are you sure you want to delete "${list.name}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(listActionProvider.notifier).deleteList(list.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back from details screen
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
