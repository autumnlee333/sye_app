// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomListModel _$CustomListModelFromJson(Map<String, dynamic> json) =>
    _CustomListModel(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      isPrivate: json['isPrivate'] as bool? ?? false,
      bookIds:
          (json['bookIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CustomListModelToJson(_CustomListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'isPrivate': instance.isPrivate,
      'bookIds': instance.bookIds,
      'createdAt': instance.createdAt.toIso8601String(),
    };
