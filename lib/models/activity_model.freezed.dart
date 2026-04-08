// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityModel {

 String get id; String get userId; String get userName; String? get userProfilePic; String get bookId; String get bookTitle; List<String> get bookAuthors; String? get bookThumbnail; ActivityType get type; double? get rating;// For reviews
 String? get text;// Review text or progress thought
 int? get page;// Current page for progress updates
 int? get totalPages;// Total pages for progress updates
 DateTime get timestamp;
/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityModelCopyWith<ActivityModel> get copyWith => _$ActivityModelCopyWithImpl<ActivityModel>(this as ActivityModel, _$identity);

  /// Serializes this ActivityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userProfilePic, userProfilePic) || other.userProfilePic == userProfilePic)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&const DeepCollectionEquality().equals(other.bookAuthors, bookAuthors)&&(identical(other.bookThumbnail, bookThumbnail) || other.bookThumbnail == bookThumbnail)&&(identical(other.type, type) || other.type == type)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,userProfilePic,bookId,bookTitle,const DeepCollectionEquality().hash(bookAuthors),bookThumbnail,type,rating,text,page,totalPages,timestamp);

@override
String toString() {
  return 'ActivityModel(id: $id, userId: $userId, userName: $userName, userProfilePic: $userProfilePic, bookId: $bookId, bookTitle: $bookTitle, bookAuthors: $bookAuthors, bookThumbnail: $bookThumbnail, type: $type, rating: $rating, text: $text, page: $page, totalPages: $totalPages, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $ActivityModelCopyWith<$Res>  {
  factory $ActivityModelCopyWith(ActivityModel value, $Res Function(ActivityModel) _then) = _$ActivityModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String userName, String? userProfilePic, String bookId, String bookTitle, List<String> bookAuthors, String? bookThumbnail, ActivityType type, double? rating, String? text, int? page, int? totalPages, DateTime timestamp
});




}
/// @nodoc
class _$ActivityModelCopyWithImpl<$Res>
    implements $ActivityModelCopyWith<$Res> {
  _$ActivityModelCopyWithImpl(this._self, this._then);

  final ActivityModel _self;
  final $Res Function(ActivityModel) _then;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? userProfilePic = freezed,Object? bookId = null,Object? bookTitle = null,Object? bookAuthors = null,Object? bookThumbnail = freezed,Object? type = null,Object? rating = freezed,Object? text = freezed,Object? page = freezed,Object? totalPages = freezed,Object? timestamp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userProfilePic: freezed == userProfilePic ? _self.userProfilePic : userProfilePic // ignore: cast_nullable_to_non_nullable
as String?,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,bookAuthors: null == bookAuthors ? _self.bookAuthors : bookAuthors // ignore: cast_nullable_to_non_nullable
as List<String>,bookThumbnail: freezed == bookThumbnail ? _self.bookThumbnail : bookThumbnail // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityType,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityModel].
extension ActivityModelPatterns on ActivityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  String? userProfilePic,  String bookId,  String bookTitle,  List<String> bookAuthors,  String? bookThumbnail,  ActivityType type,  double? rating,  String? text,  int? page,  int? totalPages,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.userProfilePic,_that.bookId,_that.bookTitle,_that.bookAuthors,_that.bookThumbnail,_that.type,_that.rating,_that.text,_that.page,_that.totalPages,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  String? userProfilePic,  String bookId,  String bookTitle,  List<String> bookAuthors,  String? bookThumbnail,  ActivityType type,  double? rating,  String? text,  int? page,  int? totalPages,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _ActivityModel():
return $default(_that.id,_that.userId,_that.userName,_that.userProfilePic,_that.bookId,_that.bookTitle,_that.bookAuthors,_that.bookThumbnail,_that.type,_that.rating,_that.text,_that.page,_that.totalPages,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String userName,  String? userProfilePic,  String bookId,  String bookTitle,  List<String> bookAuthors,  String? bookThumbnail,  ActivityType type,  double? rating,  String? text,  int? page,  int? totalPages,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.userProfilePic,_that.bookId,_that.bookTitle,_that.bookAuthors,_that.bookThumbnail,_that.type,_that.rating,_that.text,_that.page,_that.totalPages,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityModel implements ActivityModel {
  const _ActivityModel({required this.id, required this.userId, required this.userName, this.userProfilePic, required this.bookId, required this.bookTitle, final  List<String> bookAuthors = const [], this.bookThumbnail, required this.type, this.rating, this.text, this.page, this.totalPages, required this.timestamp}): _bookAuthors = bookAuthors;
  factory _ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);

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
@override final  ActivityType type;
@override final  double? rating;
// For reviews
@override final  String? text;
// Review text or progress thought
@override final  int? page;
// Current page for progress updates
@override final  int? totalPages;
// Total pages for progress updates
@override final  DateTime timestamp;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityModelCopyWith<_ActivityModel> get copyWith => __$ActivityModelCopyWithImpl<_ActivityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userProfilePic, userProfilePic) || other.userProfilePic == userProfilePic)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&const DeepCollectionEquality().equals(other._bookAuthors, _bookAuthors)&&(identical(other.bookThumbnail, bookThumbnail) || other.bookThumbnail == bookThumbnail)&&(identical(other.type, type) || other.type == type)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,userProfilePic,bookId,bookTitle,const DeepCollectionEquality().hash(_bookAuthors),bookThumbnail,type,rating,text,page,totalPages,timestamp);

@override
String toString() {
  return 'ActivityModel(id: $id, userId: $userId, userName: $userName, userProfilePic: $userProfilePic, bookId: $bookId, bookTitle: $bookTitle, bookAuthors: $bookAuthors, bookThumbnail: $bookThumbnail, type: $type, rating: $rating, text: $text, page: $page, totalPages: $totalPages, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$ActivityModelCopyWith<$Res> implements $ActivityModelCopyWith<$Res> {
  factory _$ActivityModelCopyWith(_ActivityModel value, $Res Function(_ActivityModel) _then) = __$ActivityModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String userName, String? userProfilePic, String bookId, String bookTitle, List<String> bookAuthors, String? bookThumbnail, ActivityType type, double? rating, String? text, int? page, int? totalPages, DateTime timestamp
});




}
/// @nodoc
class __$ActivityModelCopyWithImpl<$Res>
    implements _$ActivityModelCopyWith<$Res> {
  __$ActivityModelCopyWithImpl(this._self, this._then);

  final _ActivityModel _self;
  final $Res Function(_ActivityModel) _then;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? userProfilePic = freezed,Object? bookId = null,Object? bookTitle = null,Object? bookAuthors = null,Object? bookThumbnail = freezed,Object? type = null,Object? rating = freezed,Object? text = freezed,Object? page = freezed,Object? totalPages = freezed,Object? timestamp = null,}) {
  return _then(_ActivityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userProfilePic: freezed == userProfilePic ? _self.userProfilePic : userProfilePic // ignore: cast_nullable_to_non_nullable
as String?,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,bookAuthors: null == bookAuthors ? _self._bookAuthors : bookAuthors // ignore: cast_nullable_to_non_nullable
as List<String>,bookThumbnail: freezed == bookThumbnail ? _self.bookThumbnail : bookThumbnail // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityType,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
