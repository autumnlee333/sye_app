import 'package:cloud_firestore/cloud_firestore.dart';

class FollowService {
  final FirebaseFirestore _firestore;

  FollowService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Reference to the following sub-collection of a user
  CollectionReference<Map<String, dynamic>> _followingCollection(String uid) =>
      _firestore.collection('users').doc(uid).collection('following');

  /// Reference to the followers sub-collection of a user
  CollectionReference<Map<String, dynamic>> _followersCollection(String uid) =>
      _firestore.collection('users').doc(uid).collection('followers');

  /// Follows a user.
  /// Uses a [WriteBatch] to ensure atomicity.
  Future<void> followUser(String followerId, String followedId) async {
    final batch = _firestore.batch();

    // Add to follower's following sub-collection
    batch.set(_followingCollection(followerId).doc(followedId), {
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Add to followed's followers sub-collection
    batch.set(_followersCollection(followedId).doc(followerId), {
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Increment follower's following count
    batch.update(_firestore.collection('users').doc(followerId), {
      'followingCount': FieldValue.increment(1),
    });

    // Increment followed's follower count
    batch.update(_firestore.collection('users').doc(followedId), {
      'followerCount': FieldValue.increment(1),
    });

    try {
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  /// Unfollows a user.
  /// Uses a [WriteBatch] to ensure atomicity.
  Future<void> unfollowUser(String followerId, String followedId) async {
    final batch = _firestore.batch();

    // Remove from follower's following sub-collection
    batch.delete(_followingCollection(followerId).doc(followedId));

    // Remove from followed's followers sub-collection
    batch.delete(_followersCollection(followedId).doc(followerId));

    // Decrement follower's following count
    batch.update(_firestore.collection('users').doc(followerId), {
      'followingCount': FieldValue.increment(-1),
    });

    // Decrement followed's follower count
    batch.update(_firestore.collection('users').doc(followedId), {
      'followerCount': FieldValue.increment(-1),
    });

    try {
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  /// Checks if a user is following another user.
  Stream<bool> isFollowing(String followerId, String followedId) {
    return _followingCollection(followerId)
        .doc(followedId)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }
}
