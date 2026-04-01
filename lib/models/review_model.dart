import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
abstract class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    required String userId,
    required String userName,
    String? userProfilePic,
    required String bookId,
    required String bookTitle,
    @Default([]) List<String> bookAuthors,
    String? bookThumbnail,
    required double rating,
    required String reviewText,
    required DateTime timestamp,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);
}
