import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseStorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Uploads a profile picture to Firebase Storage and returns the download URL.
  Future<String> uploadProfilePicture(String userId, File file) async {
    try {
      if (!await file.exists()) {
        throw Exception('Source file does not exist at path: ${file.path}');
      }

      final extension = path.extension(file.path);
      final cleanExtension = extension.replaceFirst('.', '').toLowerCase();
      final contentType = cleanExtension == 'jpg' || cleanExtension == 'jpeg' 
          ? 'image/jpeg' 
          : 'image/$cleanExtension';

      final ref = _storage.ref().child('profile_pics').child('$userId$extension');
      
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: contentType),
      );
      
      return await uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Firebase Storage Error: ${e.message} (Code: ${e.code})');
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }
}
