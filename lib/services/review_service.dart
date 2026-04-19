import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';
import '../models/activity_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore;

  ReviewService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _reviewsCollection =>
      _firestore.collection('reviews');

  CollectionReference<Map<String, dynamic>> get _activitiesCollection =>
      _firestore.collection('activities');

  /// Saves a review and its corresponding activity atomically.
  Future<void> saveReviewWithActivity(ReviewModel review) async {
    final batch = _firestore.batch();
    
    // 1. Prepare Review Doc
    final reviewDocRef = review.id.isEmpty 
        ? _reviewsCollection.doc() 
        : _reviewsCollection.doc(review.id);
    
    // 2. Prepare Activity Doc
    final activityDocRef = (review.activityId != null && review.activityId!.isNotEmpty)
        ? _activitiesCollection.doc(review.activityId)
        : _activitiesCollection.doc();
        
    final finalReview = review.copyWith(
      id: reviewDocRef.id,
      activityId: activityDocRef.id,
    );
    
    final activity = ActivityModel(
      id: activityDocRef.id,
      userId: finalReview.userId,
      userName: finalReview.userName,
      userProfilePic: finalReview.userProfilePic,
      bookId: finalReview.bookId,
      bookTitle: finalReview.bookTitle,
      bookAuthors: finalReview.bookAuthors,
      bookThumbnail: finalReview.bookThumbnail,
      type: ActivityType.review,
      text: finalReview.reviewText,
      rating: finalReview.rating,
      reviewId: finalReview.id,
      timestamp: finalReview.timestamp,
    );

    batch.set(reviewDocRef, finalReview.toJson());
    batch.set(activityDocRef, activity.toJson());
    
    await batch.commit();
  }

  /// Deletes a review and its linked activity.
  Future<void> deleteReviewWithActivity(String reviewId, String? activityId) async {
    final batch = _firestore.batch();
    
    batch.delete(_reviewsCollection.doc(reviewId));
    if (activityId != null && activityId.isNotEmpty) {
      batch.delete(_activitiesCollection.doc(activityId));
    }
    
    await batch.commit();
  }

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
        .snapshots()
        .map((snapshot) {
      final reviews = snapshot.docs.map((doc) => ReviewModel.fromJson(doc.data())).toList();
      // Sort client-side to avoid index requirement
      reviews.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return reviews;
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
