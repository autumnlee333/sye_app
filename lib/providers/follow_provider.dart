import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/follow_service.dart';
import 'auth_provider.dart';

/// Provider for the [FollowService].
final followServiceProvider = Provider<FollowService>((ref) {
  return FollowService();
});

/// Streams whether the current user is following the [targetUserId].
final isFollowingProvider = StreamProvider.family<bool, String>((ref, targetUserId) {
  final currentUserId = ref.watch(authProvider).value?.uid;
  if (currentUserId == null) return Stream.value(false);

  return ref.watch(followServiceProvider).isFollowing(currentUserId, targetUserId);
});

/// Streams the list of IDs that the current user is following.
final followingIdsProvider = StreamProvider<List<String>>((ref) {
  final currentUserId = ref.watch(authProvider).value?.uid;
  if (currentUserId == null) return Stream.value([]);

  return ref.watch(followServiceProvider).watchFollowingIds(currentUserId);
});

/// A notifier to manage follow/unfollow actions.
class FollowNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> follow(String targetUserId) async {
    final currentUserId = ref.read(authProvider).value?.uid;
    if (currentUserId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(followServiceProvider).followUser(currentUserId, targetUserId);
    });
  }

  Future<void> unfollow(String targetUserId) async {
    final currentUserId = ref.read(authProvider).value?.uid;
    if (currentUserId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(followServiceProvider).unfollowUser(currentUserId, targetUserId);
    });
  }
}

final followActionProvider = AsyncNotifierProvider<FollowNotifier, void>(
  FollowNotifier.new,
);
