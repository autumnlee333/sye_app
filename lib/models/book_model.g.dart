// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookModel _$BookModelFromJson(Map<String, dynamic> json) => _BookModel(
  id: json['id'] as String,
  title: json['title'] as String,
  authors:
      (json['authors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  description: json['description'] as String?,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  pageCount: (json['pageCount'] as num?)?.toInt(),
  averageRating: (json['averageRating'] as num?)?.toDouble(),
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$BookModelToJson(_BookModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authors': instance.authors,
      'description': instance.description,
      'thumbnailUrl': instance.thumbnailUrl,
      'pageCount': instance.pageCount,
      'averageRating': instance.averageRating,
      'categories': instance.categories,
    };
