import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_model.dart';
import '../providers/book_provider.dart';
import '../providers/review_provider.dart';
import '../providers/list_provider.dart';

class BookDetailsScreen extends ConsumerWidget {
  final String bookId;
  final BookModel? initialBook;

  const BookDetailsScreen({
    super.key,
    required this.bookId,
    this.initialBook,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(singleBookProvider(bookId));
    final reviewsAsync = ref.watch(bookReviewsProvider(bookId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add),
            onPressed: () {
              final book = bookAsync.value ?? initialBook;
              if (book != null) {
                _showAddToListDialog(context, ref, book.id);
              }
            },
          ),
        ],
      ),
      body: bookAsync.when(
        data: (book) {
          final displayBook = book ?? initialBook;
          if (displayBook == null) {
            return const Center(child: Text('Book not found'));
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (displayBook.thumbnailUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                displayBook.thumbnailUrl!,
                                width: 120,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 120,
                                  height: 180,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.book, size: 50, color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            Container(
                              width: 120,
                              height: 180,
                              color: Colors.grey[200],
                              child: const Icon(Icons.book, size: 50),
                            ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayBook.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  displayBook.authors.join(', '),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (displayBook.averageRating != null)
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 20),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${displayBook.averageRating} / 5',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 8),
                                if (displayBook.pageCount != null)
                                  Text('${displayBook.pageCount} pages'),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 4,
                                  children: displayBook.categories
                                      .map((c) => Chip(
                                            label: Text(c, style: const TextStyle(fontSize: 10)),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Description',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        displayBook.description ?? 'No description available.',
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),
                      const Text(
                        'Reader Reviews',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              reviewsAsync.when(
                data: (reviews) {
                  if (reviews.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No reviews yet. Be the first to review!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final review = reviews[index];
                        return _ReviewListItem(review: review);
                      },
                      childCount: reviews.length,
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Center(child: Text('Error loading reviews: $e')),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showAddToListDialog(BuildContext context, WidgetRef ref, String bookId) {
    final listsAsync = ref.watch(userListsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Custom List'),
        content: SizedBox(
          width: double.maxFinite,
          child: listsAsync.when(
            data: (lists) {
              if (lists.isEmpty) {
                return const Text('You haven\'t created any custom lists yet. Go to your Library to create one!');
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  final list = lists[index];
                  final isAlreadyInList = list.bookIds.contains(bookId);

                  return ListTile(
                    leading: Icon(list.isPrivate ? Icons.lock_outline : Icons.list),
                    title: Text(list.name),
                    trailing: isAlreadyInList ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.add),
                    onTap: isAlreadyInList ? null : () {
                      ref.read(listActionProvider.notifier).addBookToList(list.id, bookId);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to ${list.name}')),
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ],
      ),
    );
  }
}

class _ReviewListItem extends StatelessWidget {
  final dynamic review;

  const _ReviewListItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: review.userProfilePic != null && review.userProfilePic!.isNotEmpty
                      ? NetworkImage(review.userProfilePic!)
                      : null,
                  child: review.userProfilePic == null || review.userProfilePic!.isEmpty
                      ? const Icon(Icons.person, size: 16)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < review.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 14,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${review.timestamp.day}/${review.timestamp.month}/${review.timestamp.year}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            if (review.reviewText.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(review.reviewText),
            ],
          ],
        ),
      ),
    );
  }
}
