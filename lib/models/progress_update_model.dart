import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_update_model.freezed.dart';
part 'progress_update_model.g.dart';

@freezed
abstract class ProgressUpdateModel with _$ProgressUpdateModel {
  const factory ProgressUpdateModel({
    required String id,
    required String bookId,
    required int page,
    String? comment,
    required DateTime timestamp,
  }) = _ProgressUpdateModel;

  factory ProgressUpdateModel.fromJson(Map<String, dynamic> json) => _$ProgressUpdateModelFromJson(json);
}
