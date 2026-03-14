import 'package:flutter_test/flutter_test.dart';
import 'package:sye_app/models/user_model.dart';

void main() {
  group('UserModel', () {
    const tUid = '123';
    const tDisplayName = 'Autumn Lee';
    const tBio = 'A book lover.';
    const tProfilePicUrl = 'https://example.com/pic.jpg';
    final tFavoriteGenres = ['Sci-Fi', 'Fantasy'];

    final tUser = UserModel(
      uid: tUid,
      displayName: tDisplayName,
      bio: tBio,
      profilePicUrl: tProfilePicUrl,
      favoriteGenres: tFavoriteGenres,
    );

    final tJson = {
      'uid': tUid,
      'displayName': tDisplayName,
      'bio': tBio,
      'profilePicUrl': tProfilePicUrl,
      'favoriteGenres': tFavoriteGenres,
    };

    test('should be a valid UserModel from JSON', () {
      // ACT
      final result = UserModel.fromJson(tJson);

      // ASSERT
      expect(result, tUser);
    });

    test('should return a valid JSON map from UserModel', () {
      // ACT
      final result = tUser.toJson();

      // ASSERT
      expect(result, tJson);
    });

    test('should support copyWith', () {
      // ACT
      final updatedUser = tUser.copyWith(displayName: 'Autumn');

      // ASSERT
      expect(updatedUser.displayName, 'Autumn');
      expect(updatedUser.uid, tUid);
    });
  });
}
