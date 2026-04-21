import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../providers/book_provider.dart';
import '../providers/activity_provider.dart';
import '../providers/follow_provider.dart';
import '../providers/goal_provider.dart';
import '../models/goal_model.dart';
import '../widgets/book_card.dart';
import '../widgets/activity_card.dart';
import 'select_favorites_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(authProvider).value?.uid;
    final targetUserId = userId ?? currentUserId;

    if (targetUserId == null) {
      return const Center(child: Text('User not found'));
    }

    final userProfileAsync = userId == null 
        ? ref.watch(currentUserDataProvider) 
        : ref.watch(userDataProvider(userId!));

    return Scaffold(
      appBar: userId != null ? AppBar(title: const Text('Profile')) : null,
      body: userProfileAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          final isCurrentUser = user.uid == currentUserId;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user.profilePicUrl.isNotEmpty
                          ? NetworkImage(user.profilePicUrl)
                          : null,
                      child: user.profilePicUrl.isEmpty
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    if (isCurrentUser)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(user: user),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '@${user.username}',
                  style: TextStyle(
                    fontSize: 16, 
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatColumn(label: 'Followers', count: user.followerCount),
                    const SizedBox(width: 32),
                    _StatColumn(label: 'Following', count: user.followingCount),
                  ],
                ),
                const SizedBox(height: 16),
                if (!isCurrentUser)
                  ref.watch(isFollowingProvider(user.uid)).when(
                        data: (isFollowing) => SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isFollowing) {
                                ref.read(followActionProvider.notifier).unfollow(user.uid);
                              } else {
                                ref.read(followActionProvider.notifier).follow(user.uid);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFollowing ? Colors.grey[200] : null,
                              foregroundColor: isFollowing ? Colors.black : null,
                            ),
                            child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                          ),
                        ),
                        loading: () => const SizedBox(
                          height: 36,
                          width: 36,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (_, __) => const Text('Error'),
                      ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: user.favoriteGenres.map((genre) => Chip(
                    label: Text(genre, style: const TextStyle(fontSize: 12)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )).toList(),
                ),
                const SizedBox(height: 24),
                if (isCurrentUser) ...[
                  const Divider(),
                  const _GoalSection(),
                  const SizedBox(height: 24),
                ],
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Top 3 Favorites',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (isCurrentUser)
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SelectFavoritesScreen(
                                initialFavoriteIds: user.topFavoriteBookIds,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (user.topFavoriteBookIds.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      isCurrentUser 
                          ? 'No favorites added yet.\nShowcase your top 3 all-time favorite books!'
                          : 'No favorites added yet.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ref.watch(bookDetailsProvider(user.topFavoriteBookIds)).when(
                        data: (books) => ListView.builder(
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
                              trailing: isCurrentUser
                                  ? IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                      onPressed: () {
                                        ref.read(userActionProvider.notifier).removeFavoriteBook(book.id);
                                      },
                                    )
                                  : null,
                            );
                          },
                        ),
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (e, _) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text('Error loading books: $e'),
                          ),
                        ),
                      ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Activity History',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                ref.watch(userActivitiesProvider(user.uid)).when(
                  data: (activities) => activities.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Text(
                            'No activities yet.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            return ActivityCard(activity: activities[index]);
                          },
                        ),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
                if (isCurrentUser) ...[
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => ref.read(authServiceProvider).signOut(),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final int count;

  const _StatColumn({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _GoalSection extends ConsumerWidget {
  const _GoalSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalProgressProvider);
    final currentYear = DateTime.now().year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$currentYear Reading Goals',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
              onPressed: () => _showAddGoalDialog(context, ref),
            ),
          ],
        ),
        if (goals.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'No goals set for this year yet.',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ...goals.map((goal) => _GoalCard(goal: goal)),
      ],
    );
  }

  void _showAddGoalDialog(BuildContext context, WidgetRef ref) {
    final targetController = TextEditingController();
    final metadataController = TextEditingController();
    GoalType selectedType = GoalType.totalBooks;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Reading Goal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<GoalType>(
                  value: selectedType,
                  items: GoalType.values.map((type) {
                    String label = '';
                    switch (type) {
                      case GoalType.totalBooks: label = 'Total Books'; break;
                      case GoalType.genreCount: label = 'Specific Genre'; break;
                      case GoalType.pageThreshold: label = 'Books over X pages'; break;
                    }
                    return DropdownMenuItem(value: type, child: Text(label));
                  }).toList(),
                  onChanged: (val) => setState(() => selectedType = val!),
                  decoration: const InputDecoration(labelText: 'Goal Type'),
                ),
                const SizedBox(height: 16),
                if (selectedType == GoalType.genreCount)
                  TextField(
                    controller: metadataController,
                    decoration: const InputDecoration(labelText: 'Genre (e.g. Fantasy)'),
                  ),
                if (selectedType == GoalType.pageThreshold)
                  TextField(
                    controller: metadataController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Page Threshold (e.g. 500)'),
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Target Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final target = int.tryParse(targetController.text) ?? 0;
                if (target > 0) {
                  ref.read(goalActionProvider.notifier).addGoal(GoalModel(
                    id: '',
                    userId: '', // Set by service
                    year: DateTime.now().year,
                    type: selectedType,
                    targetValue: target,
                    metadata: metadataController.text.trim(),
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Goal'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends ConsumerWidget {
  final GoalModel goal;
  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = (goal.currentValue / goal.targetValue).clamp(0.0, 1.0);
    final percentage = (progress * 100).toInt();

    String title = '';
    switch (goal.type) {
      case GoalType.totalBooks:
        title = 'Read ${goal.targetValue} books';
        break;
      case GoalType.genreCount:
        title = 'Read ${goal.targetValue} ${goal.metadata} books';
        break;
      case GoalType.pageThreshold:
        title = 'Read ${goal.targetValue} books over ${goal.metadata} pages';
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: Colors.blue.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                  onPressed: () => ref.read(goalActionProvider.notifier).deleteGoal(goal.id),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${goal.currentValue} / ${goal.targetValue} completed',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  '$percentage%',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
