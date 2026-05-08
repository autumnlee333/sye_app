import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'user_provider.dart';
import 'goal_provider.dart';
import 'review_provider.dart';
import 'auth_provider.dart';

class GamificationNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Check streak when the provider is initialized (app open)
    Future.microtask(() => checkStreak());

    // Automatically check for badges when goals change
    ref.listen(goalProgressProvider, (previous, next) {
      if (next.hasValue) {
        checkBadges();
      }
    });

    // Automatically check for badges when reviews change
    final userId = ref.watch(authProvider).value?.uid;
    if (userId != null) {
      ref.listen(userReviewsProvider(userId), (previous, next) {
        if (next.hasValue) {
          checkBadges();
        }
      });
    }
  }

  /// Verifies if the streak is still valid and resets it if too much time has passed.
  Future<void> checkStreak() async {
    final user = ref.read(currentUserDataProvider).value;
    if (user == null || user.lastReadingDate == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime.parse(user.lastReadingDate!);
    final normalizedLastDate = DateTime(lastDate.year, lastDate.month, lastDate.day);

    final difference = today.difference(normalizedLastDate).inDays;

    if (difference > 1) {
      // Streak broken! Reset to 0
      final updatedUser = user.copyWith(currentStreak: 0);
      await ref.read(userServiceProvider).saveUser(updatedUser);
    }
  }

  /// Updates the user's streak based on a new reading activity.
  Future<void> updateStreak() async {
    final user = ref.read(currentUserDataProvider).value;
    if (user == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    DateTime? lastDate;
    if (user.lastReadingDate != null) {
      lastDate = DateTime.parse(user.lastReadingDate!);
      lastDate = DateTime(lastDate.year, lastDate.month, lastDate.day);
    }

    int newStreak = user.currentStreak;
    
    if (lastDate == null) {
      // First activity ever
      newStreak = 1;
    } else if (today.difference(lastDate).inDays == 1) {
      // Consecutive day!
      newStreak += 1;
    } else if (today.difference(lastDate).inDays > 1) {
      // Streak broken
      newStreak = 1;
    } else if (today.difference(lastDate).inDays == 0) {
      // Already logged today, streak stays the same
      return;
    }

    final longestStreak = newStreak > user.longestStreak ? newStreak : user.longestStreak;
    
    final updatedUser = user.copyWith(
      currentStreak: newStreak,
      longestStreak: longestStreak,
      lastReadingDate: today.toIso8601String(),
    );

    await ref.read(userServiceProvider).saveUser(updatedUser);
    
    // Check for streak-based badges
    await checkBadges(updatedUser);
  }

  /// Checks if any new badges should be unlocked.
  Future<void> checkBadges([UserModel? user]) async {
    final currentUser = user ?? ref.read(currentUserDataProvider).value;
    if (currentUser == null) return;

    final unlockedIds = List<String>.from(currentUser.unlockedBadgeIds);
    bool changed = false;

    // 1. Streak Badges
    if (currentUser.currentStreak >= 7 && !unlockedIds.contains('streak_7')) {
      unlockedIds.add('streak_7');
      changed = true;
    }
    if (currentUser.currentStreak >= 30 && !unlockedIds.contains('streak_30')) {
      unlockedIds.add('streak_30');
      changed = true;
    }

    // 2. Goal Badges
    final goals = ref.read(goalProgressProvider).value ?? [];
    if (goals.any((g) => g.currentValue >= g.targetValue) && !unlockedIds.contains('goal_reached')) {
      unlockedIds.add('goal_reached');
      changed = true;
    }

    // 3. Review Badges
    final reviews = ref.read(userReviewsProvider(currentUser.uid)).value ?? [];
    if (reviews.isNotEmpty && !unlockedIds.contains('first_review')) {
      unlockedIds.add('first_review');
      changed = true;
    }

    if (changed) {
      final updatedUser = currentUser.copyWith(unlockedBadgeIds: unlockedIds);
      await ref.read(userServiceProvider).saveUser(updatedUser);
      // We could trigger a local notification or UI feedback here
    }
  }
}

final gamificationProvider = AsyncNotifierProvider<GamificationNotifier, void>(
  GamificationNotifier.new,
);
