import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_model.dart';
import '../models/review_model.dart';
import '../services/activity_service.dart';
import '../services/review_service.dart';
import 'auth_provider.dart';
import 'user_provider.dart';

/// Provider for the [ActivityService].
final activityServiceProvider = Provider<ActivityService>((ref) {
  return ActivityService();
});

/// Streams all activities for the global feed.
final allActivitiesProvider = StreamProvider<List<ActivityModel>>((ref) {
  return ref.watch(activityServiceProvider).watchAllActivities();
});

/// Streams activities for a specific user.
final userActivitiesProvider = StreamProvider.family<List<ActivityModel>, String>((ref, userId) {
  return ref.watch(activityServiceProvider).watchActivitiesByUser(userId);
});

/// A notifier to manage activity operations.
class ActivityNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> postActivity(ActivityModel activity) async {
    final user = ref.read(authProvider).value;
    final userProfile = ref.read(currentUserDataProvider).value;
    if (user == null || userProfile == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final finalActivity = activity.copyWith(
        id: activity.id.isEmpty ? '' : activity.id,
        userId: user.uid,
        userName: userProfile.displayName,
        userProfilePic: userProfile.profilePicUrl,
        timestamp: DateTime.now(),
      );
      await ref.read(activityServiceProvider).saveActivity(finalActivity);
    });
  }

  Future<void> updateActivity(ActivityModel activity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (activity.type == ActivityType.review && activity.reviewId != null) {
        // Sync update with Reviews collection
        final review = ReviewModel(
          id: activity.reviewId!,
          userId: activity.userId,
          userName: activity.userName,
          userProfilePic: activity.userProfilePic,
          bookId: activity.bookId,
          bookTitle: activity.bookTitle,
          bookAuthors: activity.bookAuthors,
          bookThumbnail: activity.bookThumbnail,
          activityId: activity.id,
          rating: activity.rating ?? 0,
          reviewText: activity.text ?? '',
          timestamp: activity.timestamp,
        );
        
        final reviewService = ReviewService(firestore: ref.read(activityServiceProvider).firestore);
        await reviewService.saveReviewWithActivity(review);
      } else {
        await ref.read(activityServiceProvider).updateActivity(activity);
      }
    });
  }

  Future<void> deleteActivity(ActivityModel activity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (activity.type == ActivityType.review && activity.reviewId != null) {
        // Atomic delete for both
        final reviewService = ReviewService(firestore: ref.read(activityServiceProvider).firestore);
        await reviewService.deleteReviewWithActivity(activity.reviewId!, activity.id);
      } else {
        await ref.read(activityServiceProvider).deleteActivity(activity.id);
      }
    });
  }
}

final activityActionProvider = AsyncNotifierProvider<ActivityNotifier, void>(
  ActivityNotifier.new,
);
