

import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

@freezed
abstract class BookModel with _$BookModel {
  const factory BookModel({
    required String id,
    required String title,
    @Default([]) List<String> authors,
    String? description,
    String? thumbnailUrl,
    int? pageCount,
    double? averageRating,
    @Default([]) List<String> categories,
  }) = _BookModel;

  factory BookModel.fromJson(Map<String, dynamic> json) => _$BookModelFromJson(json);
}
