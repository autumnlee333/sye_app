import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/book_model.dart';
import '../providers/book_provider.dart';
import '../providers/review_provider.dart';
import '../widgets/unified_add_sheet.dart';
import '../widgets/star_rating.dart';

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
            icon: const Icon(Icons.library_add),
            tooltip: 'Add to Shelf',
            onPressed: () {
              final book = bookAsync.value ?? initialBook;
              if (book != null) {
                UnifiedAddSheet.show(context, book);
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
                          if (displayBook.thumbnailUrl != null && displayBook.thumbnailUrl!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: displayBook.thumbnailUrl!,
                                width: 120,
                                height: 180,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 120,
                                  height: 180,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.book, size: 50, color: Colors.grey),
                                ),
                                errorWidget: (context, url, error) => Container(
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
                                      StarRating(rating: displayBook.averageRating!, size: 20),
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
                  backgroundColor: Colors.grey[200],
                  child: review.userProfilePic != null && review.userProfilePic!.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: review.userProfilePic!,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Icon(Icons.person, size: 16),
                            errorWidget: (context, url, error) => const Icon(Icons.person, size: 16),
                          ),
                        )
                      : const Icon(Icons.person, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      StarRating(rating: review.rating, size: 14),
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
