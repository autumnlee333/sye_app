import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_model.dart';

class ActivityService {
  final FirebaseFirestore _firestore;

  ActivityService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  CollectionReference<Map<String, dynamic>> get _activitiesCollection =>
      _firestore.collection('activities');

  /// Saves an activity to Firestore.
  Future<void> saveActivity(ActivityModel activity) async {
    try {
      final docRef = activity.id.isEmpty 
          ? _activitiesCollection.doc() 
          : _activitiesCollection.doc(activity.id);
      
      final finalActivity = activity.id.isEmpty 
          ? activity.copyWith(id: docRef.id) 
          : activity;

      await docRef.set(finalActivity.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes an activity from Firestore.
  Future<void> deleteActivity(String activityId) async {
    try {
      await _activitiesCollection.doc(activityId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Updates an activity in Firestore.
  Future<void> updateActivity(ActivityModel activity) async {
    try {
      await _activitiesCollection.doc(activity.id).update(activity.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Streams all activities for the global feed.
  Stream<List<ActivityModel>> watchAllActivities() {
    return _activitiesCollection
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ActivityModel.fromJson(doc.data())).toList();
    });
  }

  /// Streams activities for a specific user.
  Stream<List<ActivityModel>> watchActivitiesByUser(String userId) {
    return _activitiesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ActivityModel.fromJson(doc.data())).toList();
    });
  }
}
