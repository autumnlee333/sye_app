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
        return BookCard(
          title: libraryBook.title,
          authors: libraryBook.authors,
          thumbnailUrl: libraryBook.thumbnailUrl,
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
        );
      },
    );
  }
}
