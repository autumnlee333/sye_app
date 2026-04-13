import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/review_model.dart';
import '../services/review_service.dart';
import 'auth_provider.dart';
import 'user_provider.dart';

/// Provider for the [ReviewService].
final reviewServiceProvider = Provider<ReviewService>((ref) {
  return ReviewService();
});

/// Streams reviews for a specific book.
final bookReviewsProvider = StreamProvider.family<List<ReviewModel>, String>((ref, bookId) {
  return ref.watch(reviewServiceProvider).watchReviewsForBook(bookId);
});

/// Streams the current user's review for a specific book, if it exists.
final userReviewForBookProvider = StreamProvider.family<ReviewModel?, String>((ref, bookId) {
  final user = ref.watch(authProvider).value;
  if (user == null) return Stream.value(null);
  
  return ref.watch(reviewServiceProvider).watchReviewsByUser(user.uid).map((reviews) {
    try {
      return reviews.firstWhere((r) => r.bookId == bookId);
    } catch (_) {
      return null;
    }
  });
});

/// A notifier to manage review operations.
class ReviewNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> postReview({
    required String bookId,
    required String bookTitle,
    List<String> bookAuthors = const [],
    String? bookThumbnail,
    required double rating,
    required String text,
    String? id, // For editing
    String? activityId, // For editing
  }) async {
    final user = ref.read(authProvider).value;
    final userProfile = ref.read(currentUserDataProvider).value;
    if (user == null || userProfile == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final review = ReviewModel(
        id: id ?? '',
        userId: user.uid,
        userName: userProfile.displayName,
        userProfilePic: userProfile.profilePicUrl,
        bookId: bookId,
        bookTitle: bookTitle,
        bookAuthors: bookAuthors,
        bookThumbnail: bookThumbnail,
        activityId: activityId,
        rating: rating,
        reviewText: text,
        timestamp: DateTime.now(),
      );
      await ref.read(reviewServiceProvider).saveReviewWithActivity(review);
    });
  }

  Future<void> deleteReview(String reviewId, String? activityId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(reviewServiceProvider).deleteReviewWithActivity(reviewId, activityId);
    });
  }
}

final reviewActionProvider = AsyncNotifierProvider.autoDispose<ReviewNotifier, void>(
  ReviewNotifier.new,
);
