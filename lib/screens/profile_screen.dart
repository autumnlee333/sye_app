import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sye_app/providers/list_provider.dart';
import 'package:sye_app/providers/storage_provider.dart';
import 'package:sye_app/screens/list_details_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../providers/book_provider.dart';
import '../providers/activity_provider.dart';
import '../providers/follow_provider.dart';
import '../providers/goal_provider.dart';
import '../models/goal_model.dart';
import '../models/library_book_model.dart';
import '../models/badge_model.dart';
import '../widgets/book_card.dart';
import '../widgets/activity_card.dart';
import '../widgets/stats_dashboard.dart';
import 'select_favorites_screen.dart';
import 'edit_profile_screen.dart';
import 'account_settings_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isActivitiesExpanded = true;

  @override
  Widget build(BuildContext context) {
    // Listen for errors in follow actions
    ref.listen(followActionProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Follow action failed: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    final currentUserId = ref.watch(authProvider.select((v) => v.value?.uid));
    final targetUserId = widget.userId ?? currentUserId;

    if (targetUserId == null) {
      return const Center(child: Text('User not found'));
    }

    final userProfileAsync = widget.userId == null 
        ? ref.watch(currentUserDataProvider) 
        : ref.watch(userDataProvider(widget.userId!));

    return Scaffold(
      appBar: widget.userId != null ? AppBar(title: const Text('Profile')) : null,
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
                      backgroundColor: Colors.grey[200],
                      child: user.profilePicUrl.isNotEmpty
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.profilePicUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Icon(Icons.person, size: 50),
                                errorWidget: (context, url, error) => const Icon(Icons.person, size: 50),
                              ),
                            )
                          : const Icon(Icons.person, size: 50),
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
                    const SizedBox(width: 24),
                    _StatColumn(label: 'Following', count: user.followingCount),
                    const SizedBox(width: 24),
                    _StatColumn(
                      label: 'Streak', 
                      count: user.currentStreak, 
                      icon: Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (user.unlockedBadgeIds.isNotEmpty) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Badges',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: user.unlockedBadgeIds.length,
                      itemBuilder: (context, index) {
                        final badgeId = user.unlockedBadgeIds[index];
                        final badge = allBadges.firstWhere((b) => b.id == badgeId);
                        return _BadgeIcon(badge: badge);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (!isCurrentUser)
                  Consumer(
                    builder: (context, ref, child) {
                      final isFollowingAsync = ref.watch(isFollowingProvider(user.uid));
                      final actionState = ref.watch(followActionProvider);
                      final isLoading = actionState.isLoading;

                      return isFollowingAsync.when(
                        data: (isFollowing) => SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () {
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
                            child: isLoading 
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : Text(isFollowing ? 'Unfollow' : 'Follow'),
                          ),
                        ),
                        loading: () => const SizedBox(
                          height: 36,
                          width: 36,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (_, __) => const Text('Error'),
                      );
                    }
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
                  const Divider(),
                  const StatsDashboard(),
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
                _PublicListsSection(userId: targetUserId),
                const Divider(),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => setState(() => _isActivitiesExpanded = !_isActivitiesExpanded),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Activity History',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          _isActivitiesExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isActivitiesExpanded) ...[
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
                ],
                if (isCurrentUser) ...[
                  const SizedBox(height: 32),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Account Settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccountSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text('Dark Mode'),
                    trailing: Switch(
                      value: ref.watch(themeModeProvider) == ThemeMode.dark,
                      onChanged: (value) => ref.read(themeModeProvider.notifier).toggleTheme(),
                    ),
                  ),
                  const SizedBox(height: 16),
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
  final IconData? icon;
  final Color? color;

  const _StatColumn({
    required this.label, 
    required this.count,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 4),
            ],
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
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
    final goalsAsync = ref.watch(goalProgressProvider);
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
        goalsAsync.when(
          data: (goals) {
            if (goals.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'No goals set for this year yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return Column(
              children: goals.map((goal) => _GoalCard(goal: goal)).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error loading goals: $e', style: const TextStyle(color: Colors.red)),
            ),
          ),
        ),
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

class _BadgeIcon extends StatelessWidget {
  final BadgeModel badge;

  const _BadgeIcon({required this.badge});

  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.help_outline;
    switch (badge.iconAsset) {
      case 'emoji_events': iconData = Icons.emoji_events; break;
      case 'local_fire_department': iconData = Icons.local_fire_department; break;
      case 'psychology': iconData = Icons.psychology; break;
      case 'rate_review': iconData = Icons.rate_review; break;
    }

    return InkWell(
      onTap: () => _showBadgeInfo(context, iconData),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.amber.withValues(alpha: 0.1),
              child: Icon(iconData, color: Colors.amber[800], size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              badge.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeInfo(BuildContext context, IconData icon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(icon, color: Colors.amber[800], size: 48),
        title: Text(badge.name),
        content: Text(
          badge.description,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cool!'),
          ),
        ],
      ),
    );
  }
}

class _PublicListsSection extends ConsumerWidget {
  final String userId;
  const _PublicListsSection({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publicListsAsync = ref.watch(userPublicListsProvider(userId));

    return publicListsAsync.when(
      data: (lists) {
        if (lists.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Public Lists',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  final list = lists[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    child: Card(
                      elevation: 0,
                      color: Colors.blue.withValues(alpha: 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blue.withValues(alpha: 0.2)),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ListDetailsScreen(list: list),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.auto_stories, color: Colors.blue),
                              const SizedBox(height: 8),
                              Text(
                                list.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${list.bookIds.length} books',
                                style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
