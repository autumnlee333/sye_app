// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewModel {

 String get id; String get userId; String get userName; String? get userProfilePic; String get bookId; String get bookTitle; List<String> get bookAuthors; String? get bookThumbnail; String? get activityId; double get rating; String get reviewText; DateTime get timestamp;
/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewModelCopyWith<ReviewModel> get copyWith => _$ReviewModelCopyWithImpl<ReviewModel>(this as ReviewModel, _$identity);

  /// Serializes this ReviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userProfilePic, userProfilePic) || other.userProfilePic == userProfilePic)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&const DeepCollectionEquality().equals(other.bookAuthors, bookAuthors)&&(identical(other.bookThumbnail, bookThumbnail) || other.bookThumbnail == bookThumbnail)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewText, reviewText) || other.reviewText == reviewText)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,userProfilePic,bookId,bookTitle,const DeepCollectionEquality().hash(bookAuthors),bookThumbnail,activityId,rating,reviewText,timestamp);

@override
String toString() {
  return 'ReviewModel(id: $id, userId: $userId, userName: $userName, userProfilePic: $userProfilePic, bookId: $bookId, bookTitle: $bookTitle, bookAuthors: $bookAuthors, bookThumbnail: $bookThumbnail, activityId: $activityId, rating: $rating, reviewText: $reviewText, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $ReviewModelCopyWith<$Res>  {
  factory $ReviewModelCopyWith(ReviewModel value, $Res Function(ReviewModel) _then) = _$ReviewModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String userName, String? userProfilePic, String bookId, String bookTitle, List<String> bookAuthors, String? bookThumbnail, String? activityId, double rating, String reviewText, DateTime timestamp
});




}
/// @nodoc
class _$ReviewModelCopyWithImpl<$Res>
    implements $ReviewModelCopyWith<$Res> {
  _$ReviewModelCopyWithImpl(this._self, this._then);

  final ReviewModel _self;
  final $Res Function(ReviewModel) _then;

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? userProfilePic = freezed,Object? bookId = null,Object? bookTitle = null,Object? bookAuthors = null,Object? bookThumbnail = freezed,Object? activityId = freezed,Object? rating = null,Object? reviewText = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userProfilePic: freezed == userProfilePic ? _self.userProfilePic : userProfilePic // ignore: cast_nullable_to_non_nullable
as String?,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,bookAuthors: null == bookAuthors ? _self.bookAuthors : bookAuthors // ignore: cast_nullable_to_non_nullable
as List<String>,bookThumbnail: freezed == bookThumbnail ? _self.bookThumbnail : bookThumbnail // ignore: cast_nullable_to_non_nullable
as String?,activityId: freezed == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewText: null == reviewText ? _self.reviewText : reviewText // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewModel].
extension ReviewModelPatterns on ReviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewModel value)  $default,){
final _that = this;
switch (_that) {
case _ReviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  String? userProfilePic,  String bookId,  String bookTitle,  List<String> bookAuthors,  String? bookThumbnail,  String? activityId,  double rating,  String reviewText,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewModel() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.userProfilePic,_that.bookId,_that.bookTitle,_that.bookAuthors,_that.bookThumbnail,_that.activityId,_that.rating,_that.reviewText,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  String? userProfilePic,  String bookId,  String bookTitle,  List<String> bookAuthors,  String? bookThumbnail,  String? activityId,  double rating,  String reviewText,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _ReviewModel():
return $default(_that.id,_that.userId,_that.userName,_that.userProfilePic,_that.bookId,_that.bookTitle,_that.bookAuthors,_that.bookThumbnail,_that.activityId,_that.rating,_that.reviewText,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String userName,  String? userProfilePic,  String bookId,  String bookTitle,  List<String> bookAuthors,  String? bookThumbnail,  String? activityId,  double rating,  String reviewText,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _ReviewModel() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.userProfilePic,_that.bookId,_that.bookTitle,_that.bookAuthors,_that.bookThumbnail,_that.activityId,_that.rating,_that.reviewText,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewModel implements ReviewModel {
  const _ReviewModel({required this.id, required this.userId, required this.userName, this.userProfilePic, required this.bookId, required this.bookTitle, final  List<String> bookAuthors = const [], this.bookThumbnail, this.activityId, required this.rating, required this.reviewText, required this.timestamp}): _bookAuthors = bookAuthors;
  factory _ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String userName;
@override final  String? userProfilePic;
@override final  String bookId;
@override final  String bookTitle;
 final  List<String> _bookAuthors;
@override@JsonKey() List<String> get bookAuthors {
  if (_bookAuthors is EqualUnmodifiableListView) return _bookAuthors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookAuthors);
}

@override final  String? bookThumbnail;
@override final  String? activityId;
@override final  double rating;
@override final  String reviewText;
@override final  DateTime timestamp;

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewModelCopyWith<_ReviewModel> get copyWith => __$ReviewModelCopyWithImpl<_ReviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userProfilePic, userProfilePic) || other.userProfilePic == userProfilePic)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&const DeepCollectionEquality().equals(other._bookAuthors, _bookAuthors)&&(identical(other.bookThumbnail, bookThumbnail) || other.bookThumbnail == bookThumbnail)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewText, reviewText) || other.reviewText == reviewText)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,userProfilePic,bookId,bookTitle,const DeepCollectionEquality().hash(_bookAuthors),bookThumbnail,activityId,rating,reviewText,timestamp);

@override
String toString() {
  return 'ReviewModel(id: $id, userId: $userId, userName: $userName, userProfilePic: $userProfilePic, bookId: $bookId, bookTitle: $bookTitle, bookAuthors: $bookAuthors, bookThumbnail: $bookThumbnail, activityId: $activityId, rating: $rating, reviewText: $reviewText, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$ReviewModelCopyWith<$Res> implements $ReviewModelCopyWith<$Res> {
  factory _$ReviewModelCopyWith(_ReviewModel value, $Res Function(_ReviewModel) _then) = __$ReviewModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String userName, String? userProfilePic, String bookId, String bookTitle, List<String> bookAuthors, String? bookThumbnail, String? activityId, double rating, String reviewText, DateTime timestamp
});




}
/// @nodoc
class __$ReviewModelCopyWithImpl<$Res>
    implements _$ReviewModelCopyWith<$Res> {
  __$ReviewModelCopyWithImpl(this._self, this._then);

  final _ReviewModel _self;
  final $Res Function(_ReviewModel) _then;

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? userProfilePic = freezed,Object? bookId = null,Object? bookTitle = null,Object? bookAuthors = null,Object? bookThumbnail = freezed,Object? activityId = freezed,Object? rating = null,Object? reviewText = null,Object? timestamp = null,}) {
  return _then(_ReviewModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userProfilePic: freezed == userProfilePic ? _self.userProfilePic : userProfilePic // ignore: cast_nullable_to_non_nullable
as String?,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,bookAuthors: null == bookAuthors ? _self._bookAuthors : bookAuthors // ignore: cast_nullable_to_non_nullable
as List<String>,bookThumbnail: freezed == bookThumbnail ? _self.bookThumbnail : bookThumbnail // ignore: cast_nullable_to_non_nullable
as String?,activityId: freezed == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewText: null == reviewText ? _self.reviewText : reviewText // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
