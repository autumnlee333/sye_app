import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// bridge between your background authentication service and app's user interface

// single shared instance of AuthService
// one provider to access all function (signIn or signOut)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// watches the AuthService for any changes
// If a user logs in, the "feed" broadcasts user's data
// If they log out, the "feed" broadcasts null
final authProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
