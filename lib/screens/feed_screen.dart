import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/activity_provider.dart';
import '../models/activity_model.dart';
import '../widgets/activity_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(allActivitiesProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allActivitiesProvider);
          ref.invalidate(readingMemoriesProvider);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Live Board',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: _MemorySection(),
            ),
            activitiesAsync.when(
              data: (activities) => activities.isEmpty
                  ? const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_stories, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              'Your feed is quiet...\nFollow users in Community to see updates!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ActivityCard(activity: activities[index]);
                        },
                        childCount: activities.length,
                      ),
                    ),
              loading: () => const SliverFillRemaining(
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

class _MemorySection extends ConsumerWidget {
  const _MemorySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memories = ref.watch(readingMemoriesProvider);
    if (memories.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'On This Day',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...memories.map((m) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                if (m.bookThumbnail != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: m.bookThumbnail!, 
                      width: 46, 
                      height: 68, 
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 46,
                        height: 68,
                        color: Colors.white24,
                        child: const Icon(Icons.book, color: Colors.white70, size: 20),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 46,
                        height: 68,
                        color: Colors.white24,
                        child: const Icon(Icons.book, color: Colors.white70, size: 20),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 46, 
                    height: 68, 
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.book, color: Colors.white70, size: 20),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMemoryText(m),
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateTime.now().year - m.timestamp.year} year(s) ago',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8), 
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  String _getMemoryText(ActivityModel m) {
    switch (m.type) {
      case ActivityType.started:
        return 'You started reading ${m.bookTitle}';
      case ActivityType.progress:
        return 'You were on page ${m.page} of ${m.bookTitle}';
      case ActivityType.review:
        return 'You reviewed ${m.bookTitle}';
    }
  }
}
