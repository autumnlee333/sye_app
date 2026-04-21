// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoalModel _$GoalModelFromJson(Map<String, dynamic> json) => _GoalModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  year: (json['year'] as num).toInt(),
  type: $enumDecode(_$GoalTypeEnumMap, json['type']),
  targetValue: (json['targetValue'] as num).toInt(),
  currentValue: (json['currentValue'] as num?)?.toInt() ?? 0,
  metadata: json['metadata'] as String?,
);

Map<String, dynamic> _$GoalModelToJson(_GoalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'year': instance.year,
      'type': _$GoalTypeEnumMap[instance.type]!,
      'targetValue': instance.targetValue,
      'currentValue': instance.currentValue,
      'metadata': instance.metadata,
    };

const _$GoalTypeEnumMap = {
  GoalType.totalBooks: 'totalBooks',
  GoalType.genreCount: 'genreCount',
  GoalType.pageThreshold: 'pageThreshold',
};
