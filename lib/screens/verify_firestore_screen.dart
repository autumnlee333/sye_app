import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';

class VerifyFirestoreScreen extends ConsumerWidget {
  const VerifyFirestoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the auth state (to get a UID)
    final authState = ref.watch(authProvider);
    // 2. Watch the user data from Firestore
    final userData = ref.watch(currentUserDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Verification')),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Auth Error: $e')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Please log in to verify Firestore.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Authenticated as: ${user.email}'),
                Text('UID: ${user.uid}'),
                const Divider(height: 32),
                const Text('Firestore Data:', style: TextStyle(fontWeight: FontWeight.bold)),
                userData.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Firestore Error: $e'),
                  data: (data) {
                    if (data == null) {
                      return const Text('No document found for this user in Firestore.');
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Display Name: ${data.displayName}'),
                        Text('Bio: ${data.bio}'),
                        Text('Genres: ${data.favoriteGenres.join(", ")}'),
                      ],
                    );
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _createSampleUser(ref, user.uid),
                    child: const Text('Create/Update Sample Firestore User'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _createSampleUser(WidgetRef ref, String uid) async {
    final userService = ref.read(userServiceProvider);
    
    final sampleUser = UserModel(
      uid: uid,
      displayName: 'Test User ${DateTime.now().second}',
      bio: 'This is a sample bio created to verify Firestore logic.',
      profilePicUrl: 'https://via.placeholder.com/150',
      favoriteGenres: ['Sci-Fi', 'Mystery'],
    );

    try {
      await userService.saveUser(sampleUser);
      // Success snackbar
    } catch (e) {
      // Error handling
    }
  }
}
