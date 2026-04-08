import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_model.freezed.dart';
part 'activity_model.g.dart';

enum ActivityType {
  @JsonValue('review')
  review,
  @JsonValue('progress')
  progress,
  @JsonValue('started')
  started,
}

@freezed
abstract class ActivityModel with _$ActivityModel {
  const factory ActivityModel({
    required String id,
    required String userId,
    required String userName,
    String? userProfilePic,
    required String bookId,
    required String bookTitle,
    @Default([]) List<String> bookAuthors,
    String? bookThumbnail,
    required ActivityType type,
    double? rating, // For reviews
    String? text, // Review text or progress thought
    String? reviewId, // Linked review document ID
    int? page, // Current page for progress updates
    int? totalPages, // Total pages for progress updates
    required DateTime timestamp,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);
}
