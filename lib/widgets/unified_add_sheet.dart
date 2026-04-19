import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_model.dart';
import '../models/library_book_model.dart';
import '../providers/library_provider.dart';
import '../providers/list_provider.dart';

class UnifiedAddSheet extends ConsumerWidget {
  final BookModel book;

  const UnifiedAddSheet({super.key, required this.book});

  static void show(BuildContext context, BookModel book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => UnifiedAddSheet(book: book),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(userListsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Add to Shelf', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              ...ReadingStatus.values.map((status) => ListTile(
                    leading: _getStatusIcon(status),
                    title: Text(status.label),
                    onTap: () {
                      ref.read(libraryActionProvider.notifier).addBook(book, status);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to ${status.label}')));
                    },
                  )),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('My Custom Lists', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              listsAsync.when(
                data: (lists) {
                  if (lists.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No custom lists yet.', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    );
                  }
                  return Column(
                    children: lists.map((list) {
                      final isAlreadyInList = list.bookIds.contains(book.id);
                      return ListTile(
                        leading: Icon(list.isPrivate ? Icons.lock_outline : Icons.list, color: Colors.blue),
                        title: Text(list.name),
                        trailing: isAlreadyInList ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.add),
                        onTap: isAlreadyInList
                            ? null
                            : () {
                                ref.read(listActionProvider.notifier).addBookToList(list.id, book.id);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to ${list.name}')));
                              },
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator())),
                error: (e, _) => Padding(padding: EdgeInsets.all(16.0), child: Text('Error: $e')),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _getStatusIcon(ReadingStatus status) {
    switch (status) {
      case ReadingStatus.reading:
        return const Icon(Icons.menu_book, color: Colors.orange);
      case ReadingStatus.wantToRead:
        return const Icon(Icons.bookmark_outline, color: Colors.blue);
      case ReadingStatus.finished:
        return const Icon(Icons.check_circle_outline, color: Colors.green);
    }
  }
}
