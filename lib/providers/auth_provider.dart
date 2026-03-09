import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// StreamProvider for tracking the auth state of the user
final authProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
