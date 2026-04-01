// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => _ReviewModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  userProfilePic: json['userProfilePic'] as String?,
  bookId: json['bookId'] as String,
  bookTitle: json['bookTitle'] as String,
  bookAuthors:
      (json['bookAuthors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  bookThumbnail: json['bookThumbnail'] as String?,
  rating: (json['rating'] as num).toDouble(),
  reviewText: json['reviewText'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$ReviewModelToJson(_ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userProfilePic': instance.userProfilePic,
      'bookId': instance.bookId,
      'bookTitle': instance.bookTitle,
      'bookAuthors': instance.bookAuthors,
      'bookThumbnail': instance.bookThumbnail,
      'rating': instance.rating,
      'reviewText': instance.reviewText,
      'timestamp': instance.timestamp.toIso8601String(),
    };
