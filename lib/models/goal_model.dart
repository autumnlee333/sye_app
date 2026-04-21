import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_model.freezed.dart';
part 'goal_model.g.dart';

enum GoalType {
  @JsonValue('totalBooks')
  totalBooks,
  @JsonValue('genreCount')
  genreCount,
  @JsonValue('pageThreshold')
  pageThreshold,
}

@freezed
abstract class GoalModel with _$GoalModel {
  const factory GoalModel({
    required String id,
    required String userId,
    required int year,
    required GoalType type,
    required int targetValue,
    @Default(0) int currentValue,
    String? metadata, // e.g., the specific genre name or page threshold value
  }) = _GoalModel;

  factory GoalModel.fromJson(Map<String, dynamic> json) => _$GoalModelFromJson(json);
}
