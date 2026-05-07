import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore;

  UserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Reference to the users collection
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// Creates or updates a user document in Firestore.
  Future<void> saveUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Updates only the favorite book IDs for a user.
  Future<void> updateFavoriteBooks(String uid, List<String> bookIds) async {
    try {
      await _usersCollection.doc(uid).update({
        'topFavoriteBookIds': bookIds,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves a user's data from Firestore by their UID.
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Watches a specific user's profile data.
  Stream<UserModel?> watchUser(String uid) {
    return _usersCollection.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromJson(snapshot.data()!);
      }
      return null;
    });
  }

  /// Checks if a username is already taken.
  Future<bool> isUsernameAvailable(String username) async {
    final query = await _usersCollection
        .where('username', isEqualTo: username.toLowerCase())
        .limit(1)
        .get();
    return query.docs.isEmpty;
  }

  /// Searches for users by username or display name (case-insensitive prefix search).
  Future<List<UserModel>> searchUsers(String query) async {
    if (query.isEmpty) return [];

    final searchTerm = query.toLowerCase();

    // Search by username (most accurate for finding specific people)
    final usernameSnapshot = await _usersCollection
        .where('username', isGreaterThanOrEqualTo: searchTerm)
        .where('username', isLessThanOrEqualTo: '$searchTerm\uf8ff')
        .limit(20)
        .get();

    if (usernameSnapshot.docs.isNotEmpty) {
      return usernameSnapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
    }

    // Fallback to display name if no exact username matches
    final displayNameSnapshot = await _usersCollection
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(20)
        .get();

    return displayNameSnapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  /// Deletes all Firestore data associated with a user.
  Future<void> deleteUserData(String uid) async {
    final batch = _firestore.batch();

    // 1. Delete user document
    batch.delete(_usersCollection.doc(uid));

    // 2. Delete user's activities (top-level)
    final activities = await _firestore.collection('activities')
        .where('userId', isEqualTo: uid)
        .get();
    for (var doc in activities.docs) {
      batch.delete(doc.reference);
    }

    // 3. Delete user's reviews (top-level)
    final reviews = await _firestore.collection('reviews')
        .where('userId', isEqualTo: uid)
        .get();
    for (var doc in reviews.docs) {
      batch.delete(doc.reference);
    }

    // 4. Delete user's custom lists (where they are the owner)
    final lists = await _firestore.collection('customLists')
        .where('ownerId', isEqualTo: uid)
        .get();
    for (var doc in lists.docs) {
      batch.delete(doc.reference);
    }

    // 5. Remove user from collaboratorIds in other lists
    final collabLists = await _firestore.collection('customLists')
        .where('collaboratorIds', arrayContains: uid)
        .get();
    for (var doc in collabLists.docs) {
      batch.update(doc.reference, {
        'collaboratorIds': FieldValue.arrayRemove([uid]),
      });
    }

    await batch.commit();
  }
}

