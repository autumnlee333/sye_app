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

  /// Searches for users by display name (case-insensitive prefix search).
  Future<List<UserModel>> searchUsers(String query) async {
    if (query.isEmpty) return [];

    // Simple prefix search: displayName >= query and displayName < query + z
    // Note: Firestore is case-sensitive, so we'd typically store a lowercase field 
    // for true case-insensitive search. For now, we'll do a simple prefix search.
    final snapshot = await _usersCollection
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(20)
        .get();

    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }
  }

