import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge_model.freezed.dart';
part 'badge_model.g.dart';

@freezed
abstract class BadgeModel with _$BadgeModel {
  const factory BadgeModel({
    required String id,
    required String name,
    required String description,
    required String iconAsset, // We'll use Icons for now, so maybe IconData code? 
                               // Actually, let's just use string IDs and map them to Icons in UI.
  }) = _BadgeModel;

  factory BadgeModel.fromJson(Map<String, dynamic> json) => _$BadgeModelFromJson(json);
}

const List<BadgeModel> allBadges = [
  BadgeModel(
    id: 'goal_reached',
    name: 'Goal Getter',
    description: 'You reached your first reading goal!',
    iconAsset: 'emoji_events',
  ),
  BadgeModel(
    id: 'streak_7',
    name: 'Week Warrior',
    description: 'Maintained a 7-day reading streak.',
    iconAsset: 'local_fire_department',
  ),
  BadgeModel(
    id: 'streak_30',
    name: 'Reading Machine',
    description: 'Maintained a 30-day reading streak.',
    iconAsset: 'psychology',
  ),
  BadgeModel(
    id: 'first_review',
    name: 'Literary Critic',
    description: 'Posted your first book review.',
    iconAsset: 'rate_review',
  ),
];
