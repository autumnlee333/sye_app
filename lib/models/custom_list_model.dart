import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_list_model.freezed.dart';
part 'custom_list_model.g.dart';

@freezed
abstract class CustomListModel with _$CustomListModel {
  const factory CustomListModel({
    required String id,
    required String ownerId,
    required String name,
    @Default('') String description,
    @Default(false) bool isPrivate,
    @Default([]) List<String> bookIds,
    required DateTime createdAt,
  }) = _CustomListModel;

  factory CustomListModel.fromJson(Map<String, dynamic> json) => _$CustomListModelFromJson(json);
}
