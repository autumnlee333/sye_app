// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    _ActivityModel(
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
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      rating: (json['rating'] as num?)?.toDouble(),
      text: json['text'] as String?,
      reviewId: json['reviewId'] as String?,
      page: (json['page'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ActivityModelToJson(_ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userProfilePic': instance.userProfilePic,
      'bookId': instance.bookId,
      'bookTitle': instance.bookTitle,
      'bookAuthors': instance.bookAuthors,
      'bookThumbnail': instance.bookThumbnail,
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'rating': instance.rating,
      'text': instance.text,
      'reviewId': instance.reviewId,
      'page': instance.page,
      'totalPages': instance.totalPages,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$ActivityTypeEnumMap = {
  ActivityType.review: 'review',
  ActivityType.progress: 'progress',
  ActivityType.started: 'started',
};
