// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryBookModel _$LibraryBookModelFromJson(Map<String, dynamic> json) =>
    _LibraryBookModel(
      bookId: json['bookId'] as String,
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      status: $enumDecode(_$ReadingStatusEnumMap, json['status']),
      addedAt: DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$LibraryBookModelToJson(_LibraryBookModel instance) =>
    <String, dynamic>{
      'bookId': instance.bookId,
      'title': instance.title,
      'authors': instance.authors,
      'thumbnailUrl': instance.thumbnailUrl,
      'status': _$ReadingStatusEnumMap[instance.status]!,
      'addedAt': instance.addedAt.toIso8601String(),
    };

const _$ReadingStatusEnumMap = {
  ReadingStatus.wantToRead: 'wantToRead',
  ReadingStatus.reading: 'reading',
  ReadingStatus.finished: 'finished',
};
