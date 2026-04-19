// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomListModel {

 String get id; String get ownerId; String get name; String get description; bool get isPrivate; List<String> get bookIds; DateTime get createdAt;
/// Create a copy of CustomListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomListModelCopyWith<CustomListModel> get copyWith => _$CustomListModelCopyWithImpl<CustomListModel>(this as CustomListModel, _$identity);

  /// Serializes this CustomListModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomListModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&const DeepCollectionEquality().equals(other.bookIds, bookIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,description,isPrivate,const DeepCollectionEquality().hash(bookIds),createdAt);

@override
String toString() {
  return 'CustomListModel(id: $id, ownerId: $ownerId, name: $name, description: $description, isPrivate: $isPrivate, bookIds: $bookIds, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CustomListModelCopyWith<$Res>  {
  factory $CustomListModelCopyWith(CustomListModel value, $Res Function(CustomListModel) _then) = _$CustomListModelCopyWithImpl;
@useResult
$Res call({
 String id, String ownerId, String name, String description, bool isPrivate, List<String> bookIds, DateTime createdAt
});




}
/// @nodoc
class _$CustomListModelCopyWithImpl<$Res>
    implements $CustomListModelCopyWith<$Res> {
  _$CustomListModelCopyWithImpl(this._self, this._then);

  final CustomListModel _self;
  final $Res Function(CustomListModel) _then;

/// Create a copy of CustomListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? description = null,Object? isPrivate = null,Object? bookIds = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,bookIds: null == bookIds ? _self.bookIds : bookIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomListModel].
extension CustomListModelPatterns on CustomListModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomListModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomListModel value)  $default,){
final _that = this;
switch (_that) {
case _CustomListModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomListModel value)?  $default,){
final _that = this;
switch (_that) {
case _CustomListModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerId,  String name,  String description,  bool isPrivate,  List<String> bookIds,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomListModel() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.description,_that.isPrivate,_that.bookIds,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerId,  String name,  String description,  bool isPrivate,  List<String> bookIds,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CustomListModel():
return $default(_that.id,_that.ownerId,_that.name,_that.description,_that.isPrivate,_that.bookIds,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerId,  String name,  String description,  bool isPrivate,  List<String> bookIds,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CustomListModel() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.description,_that.isPrivate,_that.bookIds,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomListModel implements CustomListModel {
  const _CustomListModel({required this.id, required this.ownerId, required this.name, this.description = '', this.isPrivate = false, final  List<String> bookIds = const [], required this.createdAt}): _bookIds = bookIds;
  factory _CustomListModel.fromJson(Map<String, dynamic> json) => _$CustomListModelFromJson(json);

@override final  String id;
@override final  String ownerId;
@override final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool isPrivate;
 final  List<String> _bookIds;
@override@JsonKey() List<String> get bookIds {
  if (_bookIds is EqualUnmodifiableListView) return _bookIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookIds);
}

@override final  DateTime createdAt;

/// Create a copy of CustomListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomListModelCopyWith<_CustomListModel> get copyWith => __$CustomListModelCopyWithImpl<_CustomListModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomListModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomListModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&const DeepCollectionEquality().equals(other._bookIds, _bookIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,description,isPrivate,const DeepCollectionEquality().hash(_bookIds),createdAt);

@override
String toString() {
  return 'CustomListModel(id: $id, ownerId: $ownerId, name: $name, description: $description, isPrivate: $isPrivate, bookIds: $bookIds, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CustomListModelCopyWith<$Res> implements $CustomListModelCopyWith<$Res> {
  factory _$CustomListModelCopyWith(_CustomListModel value, $Res Function(_CustomListModel) _then) = __$CustomListModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerId, String name, String description, bool isPrivate, List<String> bookIds, DateTime createdAt
});




}
/// @nodoc
class __$CustomListModelCopyWithImpl<$Res>
    implements _$CustomListModelCopyWith<$Res> {
  __$CustomListModelCopyWithImpl(this._self, this._then);

  final _CustomListModel _self;
  final $Res Function(_CustomListModel) _then;

/// Create a copy of CustomListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? description = null,Object? isPrivate = null,Object? bookIds = null,Object? createdAt = null,}) {
  return _then(_CustomListModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,bookIds: null == bookIds ? _self._bookIds : bookIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
