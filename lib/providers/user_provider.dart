import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'auth_provider.dart';

/// Provider for the [UserService].
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

/// Streams the current user's profile data from Firestore.
final currentUserDataProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authProvider);
  final userService = ref.watch(userServiceProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return userService.watchUser(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => Stream.value(null),
  );
});

/// Fetches any user's profile data by UID.
final userDataProvider = FutureProvider.family<UserModel?, String>((ref, uid) async {
  return ref.watch(userServiceProvider).getUser(uid);
});
