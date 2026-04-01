// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgressUpdateModel _$ProgressUpdateModelFromJson(Map<String, dynamic> json) =>
    _ProgressUpdateModel(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      page: (json['page'] as num).toInt(),
      comment: json['comment'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ProgressUpdateModelToJson(
  _ProgressUpdateModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'bookId': instance.bookId,
  'page': instance.page,
  'comment': instance.comment,
  'timestamp': instance.timestamp.toIso8601String(),
};
