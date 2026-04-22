import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal_model.dart';

class GoalService {
  final FirebaseFirestore _firestore;

  GoalService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _goalsCollection(String uid) =>
      _firestore.collection('users').doc(uid).collection('goals');

  /// Saves a goal to Firestore.
  Future<void> saveGoal(String uid, GoalModel goal) async {
    try {
      final docRef = goal.id.isEmpty 
          ? _goalsCollection(uid).doc() 
          : _goalsCollection(uid).doc(goal.id);
      
      final finalGoal = goal.copyWith(
        id: docRef.id,
        userId: uid,
      );

      await docRef.set(finalGoal.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes a goal from Firestore.
  Future<void> deleteGoal(String uid, String goalId) async {
    try {
      await _goalsCollection(uid).doc(goalId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Streams all goals for a specific user and year.
  Stream<List<GoalModel>> watchGoals(String uid, int year) {
    return _goalsCollection(uid)
        .where('year', isEqualTo: year)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => GoalModel.fromJson(doc.data())).toList();
    });
  }
}
