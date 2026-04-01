// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_update_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgressUpdateModel {

 String get id; String get bookId; int get page; String? get comment; DateTime get timestamp;
/// Create a copy of ProgressUpdateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressUpdateModelCopyWith<ProgressUpdateModel> get copyWith => _$ProgressUpdateModelCopyWithImpl<ProgressUpdateModel>(this as ProgressUpdateModel, _$identity);

  /// Serializes this ProgressUpdateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressUpdateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.page, page) || other.page == page)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,page,comment,timestamp);

@override
String toString() {
  return 'ProgressUpdateModel(id: $id, bookId: $bookId, page: $page, comment: $comment, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $ProgressUpdateModelCopyWith<$Res>  {
  factory $ProgressUpdateModelCopyWith(ProgressUpdateModel value, $Res Function(ProgressUpdateModel) _then) = _$ProgressUpdateModelCopyWithImpl;
@useResult
$Res call({
 String id, String bookId, int page, String? comment, DateTime timestamp
});




}
/// @nodoc
class _$ProgressUpdateModelCopyWithImpl<$Res>
    implements $ProgressUpdateModelCopyWith<$Res> {
  _$ProgressUpdateModelCopyWithImpl(this._self, this._then);

  final ProgressUpdateModel _self;
  final $Res Function(ProgressUpdateModel) _then;

/// Create a copy of ProgressUpdateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookId = null,Object? page = null,Object? comment = freezed,Object? timestamp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressUpdateModel].
extension ProgressUpdateModelPatterns on ProgressUpdateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressUpdateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressUpdateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressUpdateModel value)  $default,){
final _that = this;
switch (_that) {
case _ProgressUpdateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressUpdateModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressUpdateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bookId,  int page,  String? comment,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressUpdateModel() when $default != null:
return $default(_that.id,_that.bookId,_that.page,_that.comment,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bookId,  int page,  String? comment,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _ProgressUpdateModel():
return $default(_that.id,_that.bookId,_that.page,_that.comment,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bookId,  int page,  String? comment,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _ProgressUpdateModel() when $default != null:
return $default(_that.id,_that.bookId,_that.page,_that.comment,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgressUpdateModel implements ProgressUpdateModel {
  const _ProgressUpdateModel({required this.id, required this.bookId, required this.page, this.comment, required this.timestamp});
  factory _ProgressUpdateModel.fromJson(Map<String, dynamic> json) => _$ProgressUpdateModelFromJson(json);

@override final  String id;
@override final  String bookId;
@override final  int page;
@override final  String? comment;
@override final  DateTime timestamp;

/// Create a copy of ProgressUpdateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressUpdateModelCopyWith<_ProgressUpdateModel> get copyWith => __$ProgressUpdateModelCopyWithImpl<_ProgressUpdateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressUpdateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressUpdateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.page, page) || other.page == page)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,page,comment,timestamp);

@override
String toString() {
  return 'ProgressUpdateModel(id: $id, bookId: $bookId, page: $page, comment: $comment, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$ProgressUpdateModelCopyWith<$Res> implements $ProgressUpdateModelCopyWith<$Res> {
  factory _$ProgressUpdateModelCopyWith(_ProgressUpdateModel value, $Res Function(_ProgressUpdateModel) _then) = __$ProgressUpdateModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookId, int page, String? comment, DateTime timestamp
});




}
/// @nodoc
class __$ProgressUpdateModelCopyWithImpl<$Res>
    implements _$ProgressUpdateModelCopyWith<$Res> {
  __$ProgressUpdateModelCopyWithImpl(this._self, this._then);

  final _ProgressUpdateModel _self;
  final $Res Function(_ProgressUpdateModel) _then;

/// Create a copy of ProgressUpdateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookId = null,Object? page = null,Object? comment = freezed,Object? timestamp = null,}) {
  return _then(_ProgressUpdateModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
