import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(recommendationsProvider);
    final activitiesAsync = ref.watch(allActivitiesProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(recommendationsProvider);
          ref.invalidate(allActivitiesProvider);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Recommended for You',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: recommendationsAsync.when(
                  data: (books) => books.isEmpty
                      ? const Center(child: Text('Add favorite genres for better picks!'))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final book = books[index];
                            return _CompactBookCard(book: book);
                          },
                        ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Live Board',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            activitiesAsync.when(
              data: (activities) => activities.isEmpty
                  ? const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text('No activities yet. Start reading a book!')),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ActivityCard(activity: activities[index]);
                        },
                        childCount: activities.length,
                      ),
                    ),
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactBookCard extends ConsumerWidget {
  final dynamic book;
  const _CompactBookCard({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 120,
      margin: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () {
          // TODO: Book Details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: book.thumbnailUrl != null
                    ? Image.network(book.thumbnailUrl!, fit: BoxFit.cover)
                    : Container(color: Colors.grey[200], child: const Icon(Icons.book)),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              book.authors.isNotEmpty ? book.authors.first : 'Unknown',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
