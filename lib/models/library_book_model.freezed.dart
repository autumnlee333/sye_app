// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_book_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryBookModel {

 String get bookId; String get title; List<String> get authors; String? get thumbnailUrl; ReadingStatus get status; DateTime get addedAt; int get currentPage; int get totalPages; double? get averageRating; List<String> get categories;
/// Create a copy of LibraryBookModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryBookModelCopyWith<LibraryBookModel> get copyWith => _$LibraryBookModelCopyWithImpl<LibraryBookModel>(this as LibraryBookModel, _$identity);

  /// Serializes this LibraryBookModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryBookModel&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.authors, authors)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookId,title,const DeepCollectionEquality().hash(authors),thumbnailUrl,status,addedAt,currentPage,totalPages,averageRating,const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'LibraryBookModel(bookId: $bookId, title: $title, authors: $authors, thumbnailUrl: $thumbnailUrl, status: $status, addedAt: $addedAt, currentPage: $currentPage, totalPages: $totalPages, averageRating: $averageRating, categories: $categories)';
}


}

/// @nodoc
abstract mixin class $LibraryBookModelCopyWith<$Res>  {
  factory $LibraryBookModelCopyWith(LibraryBookModel value, $Res Function(LibraryBookModel) _then) = _$LibraryBookModelCopyWithImpl;
@useResult
$Res call({
 String bookId, String title, List<String> authors, String? thumbnailUrl, ReadingStatus status, DateTime addedAt, int currentPage, int totalPages, double? averageRating, List<String> categories
});




}
/// @nodoc
class _$LibraryBookModelCopyWithImpl<$Res>
    implements $LibraryBookModelCopyWith<$Res> {
  _$LibraryBookModelCopyWithImpl(this._self, this._then);

  final LibraryBookModel _self;
  final $Res Function(LibraryBookModel) _then;

/// Create a copy of LibraryBookModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookId = null,Object? title = null,Object? authors = null,Object? thumbnailUrl = freezed,Object? status = null,Object? addedAt = null,Object? currentPage = null,Object? totalPages = null,Object? averageRating = freezed,Object? categories = null,}) {
  return _then(_self.copyWith(
bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReadingStatus,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryBookModel].
extension LibraryBookModelPatterns on LibraryBookModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryBookModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryBookModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryBookModel value)  $default,){
final _that = this;
switch (_that) {
case _LibraryBookModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryBookModel value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryBookModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bookId,  String title,  List<String> authors,  String? thumbnailUrl,  ReadingStatus status,  DateTime addedAt,  int currentPage,  int totalPages,  double? averageRating,  List<String> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryBookModel() when $default != null:
return $default(_that.bookId,_that.title,_that.authors,_that.thumbnailUrl,_that.status,_that.addedAt,_that.currentPage,_that.totalPages,_that.averageRating,_that.categories);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bookId,  String title,  List<String> authors,  String? thumbnailUrl,  ReadingStatus status,  DateTime addedAt,  int currentPage,  int totalPages,  double? averageRating,  List<String> categories)  $default,) {final _that = this;
switch (_that) {
case _LibraryBookModel():
return $default(_that.bookId,_that.title,_that.authors,_that.thumbnailUrl,_that.status,_that.addedAt,_that.currentPage,_that.totalPages,_that.averageRating,_that.categories);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bookId,  String title,  List<String> authors,  String? thumbnailUrl,  ReadingStatus status,  DateTime addedAt,  int currentPage,  int totalPages,  double? averageRating,  List<String> categories)?  $default,) {final _that = this;
switch (_that) {
case _LibraryBookModel() when $default != null:
return $default(_that.bookId,_that.title,_that.authors,_that.thumbnailUrl,_that.status,_that.addedAt,_that.currentPage,_that.totalPages,_that.averageRating,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryBookModel implements LibraryBookModel {
  const _LibraryBookModel({required this.bookId, required this.title, required final  List<String> authors, this.thumbnailUrl, required this.status, required this.addedAt, this.currentPage = 0, this.totalPages = 0, this.averageRating, final  List<String> categories = const []}): _authors = authors,_categories = categories;
  factory _LibraryBookModel.fromJson(Map<String, dynamic> json) => _$LibraryBookModelFromJson(json);

@override final  String bookId;
@override final  String title;
 final  List<String> _authors;
@override List<String> get authors {
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authors);
}

@override final  String? thumbnailUrl;
@override final  ReadingStatus status;
@override final  DateTime addedAt;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int totalPages;
@override final  double? averageRating;
 final  List<String> _categories;
@override@JsonKey() List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of LibraryBookModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryBookModelCopyWith<_LibraryBookModel> get copyWith => __$LibraryBookModelCopyWithImpl<_LibraryBookModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryBookModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryBookModel&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._authors, _authors)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookId,title,const DeepCollectionEquality().hash(_authors),thumbnailUrl,status,addedAt,currentPage,totalPages,averageRating,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'LibraryBookModel(bookId: $bookId, title: $title, authors: $authors, thumbnailUrl: $thumbnailUrl, status: $status, addedAt: $addedAt, currentPage: $currentPage, totalPages: $totalPages, averageRating: $averageRating, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$LibraryBookModelCopyWith<$Res> implements $LibraryBookModelCopyWith<$Res> {
  factory _$LibraryBookModelCopyWith(_LibraryBookModel value, $Res Function(_LibraryBookModel) _then) = __$LibraryBookModelCopyWithImpl;
@override @useResult
$Res call({
 String bookId, String title, List<String> authors, String? thumbnailUrl, ReadingStatus status, DateTime addedAt, int currentPage, int totalPages, double? averageRating, List<String> categories
});




}
/// @nodoc
class __$LibraryBookModelCopyWithImpl<$Res>
    implements _$LibraryBookModelCopyWith<$Res> {
  __$LibraryBookModelCopyWithImpl(this._self, this._then);

  final _LibraryBookModel _self;
  final $Res Function(_LibraryBookModel) _then;

/// Create a copy of LibraryBookModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookId = null,Object? title = null,Object? authors = null,Object? thumbnailUrl = freezed,Object? status = null,Object? addedAt = null,Object? currentPage = null,Object? totalPages = null,Object? averageRating = freezed,Object? categories = null,}) {
  return _then(_LibraryBookModel(
bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReadingStatus,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
