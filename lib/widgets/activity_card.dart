import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/activity_model.dart';
import '../providers/auth_provider.dart';
import '../providers/activity_provider.dart';
import '../screens/profile_screen.dart';
import '../screens/book_details_screen.dart';
import 'star_rating.dart';

class ActivityCard extends ConsumerWidget {
  final ActivityModel activity;
  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(authProvider.select((v) => v.value?.uid));
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
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(userId: activity.userId),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey[200],
                    child: activity.userProfilePic != null && activity.userProfilePic!.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: activity.userProfilePic!,
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Icon(Icons.person, size: 16),
                              errorWidget: (context, url, error) => const Icon(Icons.person, size: 16),
                            ),
                          )
                        : const Icon(Icons.person, size: 16),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(activity.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BookDetailsScreen(
                                bookId: activity.bookId,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          _getActivityLabel(activity),
                          style: const TextStyle(
                            fontSize: 12, 
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (activity.type == ActivityType.review && activity.rating != null)
                  StarRating(rating: activity.rating!, size: 16),
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
    double rating = activity.rating ?? 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(activity.type == ActivityType.review ? 'Edit Review' : 'Edit Thought'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (activity.type == ActivityType.review) ...[
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTapDown: (details) {
                          final double relativePosition = details.localPosition.dx / constraints.maxWidth;
                          double newRating = (relativePosition * 5 * 2).ceil() / 2;
                          if (newRating < 0.5) newRating = 0.5;
                          if (newRating > 5.0) newRating = 5.0;
                          setDialogState(() => rating = newRating);
                        },
                        onPanUpdate: (details) {
                           RenderBox box = context.findRenderObject() as RenderBox;
                           Offset localPosition = box.globalToLocal(details.globalPosition);
                           final double relativePosition = localPosition.dx / constraints.maxWidth;
                           double newRating = (relativePosition * 5 * 2).ceil() / 2;
                           if (newRating < 0.5) newRating = 0.5;
                           if (newRating > 5.0) newRating = 5.0;
                           setDialogState(() => rating = newRating);
                        },
                        child: StarRating(rating: rating, size: 40),
                      );
                    },
                  ),
                  Text('$rating stars', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                ],
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
                  rating: rating > 0 ? rating : activity.rating,
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
