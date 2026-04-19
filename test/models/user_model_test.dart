import 'package:flutter_test/flutter_test.dart';
import 'package:sye_app/models/user_model.dart';

void main() {
  /// These tests verify that the [UserModel] (and the machinery generated 
  /// by Freezed/JSON Serializable) is functioning correctly.
  group('UserModel', () {
    // 1. Setup "Ground Truth" data.
    // We define a sample user object (tUser) and its identical JSON map (tJson).
    // These act as our "control group" for the following tests.
    const tUid = '123';
    const tDisplayName = 'Autumn Lee';
    const tUsername = 'autumn_lee';
    const tBio = 'A book lover.';
    const tProfilePicUrl = 'https://example.com/pic.jpg';
    final tFavoriteGenres = ['Sci-Fi', 'Fantasy'];

    final tUser = UserModel(
      uid: tUid,
      displayName: tDisplayName,
      username: tUsername,
      bio: tBio,
      profilePicUrl: tProfilePicUrl,
      favoriteGenres: tFavoriteGenres,
    );

    final tJson = {
      'uid': tUid,
      'displayName': tDisplayName,
      'username': tUsername,
      'bio': tBio,
      'profilePicUrl': tProfilePicUrl,
      'favoriteGenres': tFavoriteGenres,
      'topFavoriteBookIds': <String>[],
      'followerCount': 0,
      'followingCount': 0,
    };

    // 2. Test Deserialization (JSON -> Object)
    // Ensures we can correctly convert raw Firestore data into a Dart object.
    test('should be a valid UserModel from JSON', () {
      // ACT: Convert the control JSON map into a UserModel
      final result = UserModel.fromJson(tJson);

      // ASSERT: Verify it matches our control user object.
      expect(result, tUser);
    });

    test('should provide an empty string for username if missing from JSON', () {
      // ARRANGE: A JSON map missing the 'username' key (legacy data)
      final legacyJson = Map<String, dynamic>.from(tJson)..remove('username');

      // ACT
      final result = UserModel.fromJson(legacyJson);

      // ASSERT
      expect(result.username, '');
    });

    // 3. Test Serialization (Object -> JSON)
    // Ensures we can correctly convert our object into a format Firestore understands.
    test('should return a valid JSON map from UserModel', () {
      // ACT: Convert our control user object into a JSON map
      final result = tUser.toJson();

      // ASSERT: Verify it matches our control JSON map.
      expect(result, tJson);
    });

    // 4. Test Immutability (Editing)
    // Ensures we can safely create modified copies of a user without changing 
    // the original object.
    test('should support copyWith', () {
      // ACT: Create a new user by copying tUser and updating only the name
      final updatedUser = tUser.copyWith(displayName: 'Autumn');

      // ASSERT: Verify the name was updated while other fields (like uid) remained the same.
      expect(updatedUser.displayName, 'Autumn');
      expect(updatedUser.uid, tUid);
    });
  });
}
