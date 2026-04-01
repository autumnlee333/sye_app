import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore;

  ReviewService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _reviewsCollection =>
      _firestore.collection('reviews');

  /// Saves a review to Firestore. Creates a new doc if ID is empty.
  Future<void> saveReview(ReviewModel review) async {
    try {
      final docRef = review.id.isEmpty 
          ? _reviewsCollection.doc() 
          : _reviewsCollection.doc(review.id);
      
      final finalReview = review.id.isEmpty 
          ? review.copyWith(id: docRef.id) 
          : review;

      await docRef.set(finalReview.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes a review from Firestore.
  Future<void> deleteReview(String reviewId) async {
    try {
      await _reviewsCollection.doc(reviewId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Streams all reviews for a specific book.
  Stream<List<ReviewModel>> watchReviewsForBook(String bookId) {
    return _reviewsCollection
        .where('bookId', isEqualTo: bookId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromJson(doc.data())).toList();
    });
  }

  /// Streams all reviews (global feed).
  Stream<List<ReviewModel>> watchAllReviews() {
    return _reviewsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromJson(doc.data())).toList();
    });
  }

  /// Streams reviews by a specific user.
  Stream<List<ReviewModel>> watchReviewsByUser(String userId) {
    return _reviewsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromJson(doc.data())).toList();
    });
  }
}
