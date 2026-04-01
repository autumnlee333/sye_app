import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_provider.dart';
import '../providers/library_provider.dart';
import '../models/library_book_model.dart';
import '../widgets/book_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(recommendationsProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(recommendationsProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recommended for You',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Based on your favorite genres',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              recommendationsAsync.when(
                data: (books) {
                  if (books.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Text('No recommendations found. Try adding more favorite genres in your profile!'),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                          // TODO: Navigate to Book Details
                        },
                        trailing: PopupMenuButton<ReadingStatus>(
                          icon: const Icon(Icons.library_add, color: Colors.blue),
                          tooltip: 'Add to Library',
                          onSelected: (status) {
                            ref.read(libraryActionProvider.notifier).addBook(book, status);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Added to ${status.label}')),
                            );
                          },
                          itemBuilder: (context) => ReadingStatus.values.map((status) {
                            return PopupMenuItem(
                              value: status,
                              child: Text(status.label),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Text('Error loading recommendations: $e'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
