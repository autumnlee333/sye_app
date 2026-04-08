import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_model.dart';
import '../services/activity_service.dart';
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
        id: '', // Will be generated
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
      await ref.read(activityServiceProvider).updateActivity(activity);
    });
  }

  Future<void> deleteActivity(String activityId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(activityServiceProvider).deleteActivity(activityId);
    });
  }
}

final activityActionProvider = AsyncNotifierProvider<ActivityNotifier, void>(
  ActivityNotifier.new,
);
