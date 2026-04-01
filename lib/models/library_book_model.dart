import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_book_model.freezed.dart';
part 'library_book_model.g.dart';

enum ReadingStatus {
  @JsonValue('wantToRead')
  wantToRead,
  @JsonValue('reading')
  reading,
  @JsonValue('finished')
  finished,
}

extension ReadingStatusExtension on ReadingStatus {
  String get label {
    switch (this) {
      case ReadingStatus.wantToRead:
        return 'Want to Read';
      case ReadingStatus.reading:
        return 'Reading';
      case ReadingStatus.finished:
        return 'Finished';
    }
  }
}

@freezed
abstract class LibraryBookModel with _$LibraryBookModel {
  const factory LibraryBookModel({
    required String bookId,
    required String title,
    required List<String> authors,
    String? thumbnailUrl,
    required ReadingStatus status,
    required DateTime addedAt,
  }) = _LibraryBookModel;

  factory LibraryBookModel.fromJson(Map<String, dynamic> json) => _$LibraryBookModelFromJson(json);
}
