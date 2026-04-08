import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_provider.dart';
import '../providers/activity_provider.dart';
import '../providers/auth_provider.dart';
import '../models/activity_model.dart';

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
                          return _ActivityCard(activity: activities[index]);
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

class _ActivityCard extends ConsumerWidget {
  final ActivityModel activity;
  const _ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(authProvider).value?.uid;
    final isOwnPost = currentUserId == activity.userId;

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
                  backgroundImage: activity.userProfilePic != null && activity.userProfilePic!.isNotEmpty
                      ? NetworkImage(activity.userProfilePic!)
                      : null,
                  child: activity.userProfilePic == null || activity.userProfilePic!.isEmpty
                      ? const Icon(Icons.person, size: 16)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(activity.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        _getActivityLabel(activity),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (activity.type == ActivityType.review && activity.rating != null)
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < activity.rating! ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ),
                if (isOwnPost)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditActivityDialog(context, ref, activity);
                      } else if (value == 'delete') {
                        _confirmDeleteActivity(context, ref, activity);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (activity.text != null && activity.text!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(activity.text!),
            ],
            const SizedBox(height: 8),
            Text(
              _formatDate(activity.timestamp),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditActivityDialog(BuildContext context, WidgetRef ref, ActivityModel activity) {
    final textController = TextEditingController(text: activity.text);
    double? rating = activity.rating;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(activity.type == ActivityType.review ? 'Edit Review' : 'Edit Thought'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (activity.type == ActivityType.review)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < (rating ?? 0) ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                      onPressed: () => setState(() => rating = index + 1.0),
                    );
                  }),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Update your thoughts...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedActivity = activity.copyWith(
                  text: textController.text.trim(),
                  rating: rating,
                );
                ref.read(activityActionProvider.notifier).updateActivity(updatedActivity);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Update saved!')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteActivity(BuildContext context, WidgetRef ref, ActivityModel activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post?'),
        content: const Text('Are you sure you want to delete this post? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(activityActionProvider.notifier).deleteActivity(activity);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _getActivityLabel(ActivityModel activity) {
    switch (activity.type) {
      case ActivityType.started:
        return 'started reading ${activity.bookTitle}';
      case ActivityType.progress:
        final percentage = activity.totalPages != null && activity.totalPages! > 0
            ? ' (${((activity.page! / activity.totalPages!) * 100).toInt()}%)'
            : '';
        return 'is on page ${activity.page} of ${activity.bookTitle}$percentage';
      case ActivityType.review:
        return 'reviewed ${activity.bookTitle}';
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
