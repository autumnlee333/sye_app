// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BadgeModel _$BadgeModelFromJson(Map<String, dynamic> json) => _BadgeModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  iconAsset: json['iconAsset'] as String,
);

Map<String, dynamic> _$BadgeModelToJson(_BadgeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'iconAsset': instance.iconAsset,
    };
