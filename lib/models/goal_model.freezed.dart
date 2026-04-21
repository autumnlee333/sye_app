// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoalModel {

 String get id; String get userId; int get year; GoalType get type; int get targetValue; int get currentValue; String? get metadata;
/// Create a copy of GoalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalModelCopyWith<GoalModel> get copyWith => _$GoalModelCopyWithImpl<GoalModel>(this as GoalModel, _$identity);

  /// Serializes this GoalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.year, year) || other.year == year)&&(identical(other.type, type) || other.type == type)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,year,type,targetValue,currentValue,metadata);

@override
String toString() {
  return 'GoalModel(id: $id, userId: $userId, year: $year, type: $type, targetValue: $targetValue, currentValue: $currentValue, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $GoalModelCopyWith<$Res>  {
  factory $GoalModelCopyWith(GoalModel value, $Res Function(GoalModel) _then) = _$GoalModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, int year, GoalType type, int targetValue, int currentValue, String? metadata
});




}
/// @nodoc
class _$GoalModelCopyWithImpl<$Res>
    implements $GoalModelCopyWith<$Res> {
  _$GoalModelCopyWithImpl(this._self, this._then);

  final GoalModel _self;
  final $Res Function(GoalModel) _then;

/// Create a copy of GoalModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? year = null,Object? type = null,Object? targetValue = null,Object? currentValue = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GoalType,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as int,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as int,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalModel].
extension GoalModelPatterns on GoalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalModel value)  $default,){
final _that = this;
switch (_that) {
case _GoalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalModel value)?  $default,){
final _that = this;
switch (_that) {
case _GoalModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  int year,  GoalType type,  int targetValue,  int currentValue,  String? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalModel() when $default != null:
return $default(_that.id,_that.userId,_that.year,_that.type,_that.targetValue,_that.currentValue,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  int year,  GoalType type,  int targetValue,  int currentValue,  String? metadata)  $default,) {final _that = this;
switch (_that) {
case _GoalModel():
return $default(_that.id,_that.userId,_that.year,_that.type,_that.targetValue,_that.currentValue,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  int year,  GoalType type,  int targetValue,  int currentValue,  String? metadata)?  $default,) {final _that = this;
switch (_that) {
case _GoalModel() when $default != null:
return $default(_that.id,_that.userId,_that.year,_that.type,_that.targetValue,_that.currentValue,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoalModel implements GoalModel {
  const _GoalModel({required this.id, required this.userId, required this.year, required this.type, required this.targetValue, this.currentValue = 0, this.metadata});
  factory _GoalModel.fromJson(Map<String, dynamic> json) => _$GoalModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  int year;
@override final  GoalType type;
@override final  int targetValue;
@override@JsonKey() final  int currentValue;
@override final  String? metadata;

/// Create a copy of GoalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalModelCopyWith<_GoalModel> get copyWith => __$GoalModelCopyWithImpl<_GoalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.year, year) || other.year == year)&&(identical(other.type, type) || other.type == type)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,year,type,targetValue,currentValue,metadata);

@override
String toString() {
  return 'GoalModel(id: $id, userId: $userId, year: $year, type: $type, targetValue: $targetValue, currentValue: $currentValue, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$GoalModelCopyWith<$Res> implements $GoalModelCopyWith<$Res> {
  factory _$GoalModelCopyWith(_GoalModel value, $Res Function(_GoalModel) _then) = __$GoalModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, int year, GoalType type, int targetValue, int currentValue, String? metadata
});




}
/// @nodoc
class __$GoalModelCopyWithImpl<$Res>
    implements _$GoalModelCopyWith<$Res> {
  __$GoalModelCopyWithImpl(this._self, this._then);

  final _GoalModel _self;
  final $Res Function(_GoalModel) _then;

/// Create a copy of GoalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? year = null,Object? type = null,Object? targetValue = null,Object? currentValue = null,Object? metadata = freezed,}) {
  return _then(_GoalModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GoalType,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as int,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as int,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
