import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'auth_provider.dart';

// Provider for UserService
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

// StreamProvider that watches the CURRENT user's Firestore document
// based on their Firebase Auth UID.
final currentUserDataProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authProvider);
  final userService = ref.watch(userServiceProvider);

  // If there's no authenticated user, the data stream is null.
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return userService.watchUser(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => Stream.value(null),
  );
});
