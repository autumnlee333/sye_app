// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get uid; String get displayName; String get bio; String get profilePicUrl; List<String> get favoriteGenres; List<String> get topFavoriteBookIds; int get followerCount; int get followingCount;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.profilePicUrl, profilePicUrl) || other.profilePicUrl == profilePicUrl)&&const DeepCollectionEquality().equals(other.favoriteGenres, favoriteGenres)&&const DeepCollectionEquality().equals(other.topFavoriteBookIds, topFavoriteBookIds)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,displayName,bio,profilePicUrl,const DeepCollectionEquality().hash(favoriteGenres),const DeepCollectionEquality().hash(topFavoriteBookIds),followerCount,followingCount);

@override
String toString() {
  return 'UserModel(uid: $uid, displayName: $displayName, bio: $bio, profilePicUrl: $profilePicUrl, favoriteGenres: $favoriteGenres, topFavoriteBookIds: $topFavoriteBookIds, followerCount: $followerCount, followingCount: $followingCount)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String uid, String displayName, String bio, String profilePicUrl, List<String> favoriteGenres, List<String> topFavoriteBookIds, int followerCount, int followingCount
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? displayName = null,Object? bio = null,Object? profilePicUrl = null,Object? favoriteGenres = null,Object? topFavoriteBookIds = null,Object? followerCount = null,Object? followingCount = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,profilePicUrl: null == profilePicUrl ? _self.profilePicUrl : profilePicUrl // ignore: cast_nullable_to_non_nullable
as String,favoriteGenres: null == favoriteGenres ? _self.favoriteGenres : favoriteGenres // ignore: cast_nullable_to_non_nullable
as List<String>,topFavoriteBookIds: null == topFavoriteBookIds ? _self.topFavoriteBookIds : topFavoriteBookIds // ignore: cast_nullable_to_non_nullable
as List<String>,followerCount: null == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as int,followingCount: null == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String displayName,  String bio,  String profilePicUrl,  List<String> favoriteGenres,  List<String> topFavoriteBookIds,  int followerCount,  int followingCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.uid,_that.displayName,_that.bio,_that.profilePicUrl,_that.favoriteGenres,_that.topFavoriteBookIds,_that.followerCount,_that.followingCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String displayName,  String bio,  String profilePicUrl,  List<String> favoriteGenres,  List<String> topFavoriteBookIds,  int followerCount,  int followingCount)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.uid,_that.displayName,_that.bio,_that.profilePicUrl,_that.favoriteGenres,_that.topFavoriteBookIds,_that.followerCount,_that.followingCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String displayName,  String bio,  String profilePicUrl,  List<String> favoriteGenres,  List<String> topFavoriteBookIds,  int followerCount,  int followingCount)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.uid,_that.displayName,_that.bio,_that.profilePicUrl,_that.favoriteGenres,_that.topFavoriteBookIds,_that.followerCount,_that.followingCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.uid, required this.displayName, required this.bio, required this.profilePicUrl, required final  List<String> favoriteGenres, final  List<String> topFavoriteBookIds = const [], this.followerCount = 0, this.followingCount = 0}): _favoriteGenres = favoriteGenres,_topFavoriteBookIds = topFavoriteBookIds;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String uid;
@override final  String displayName;
@override final  String bio;
@override final  String profilePicUrl;
 final  List<String> _favoriteGenres;
@override List<String> get favoriteGenres {
  if (_favoriteGenres is EqualUnmodifiableListView) return _favoriteGenres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteGenres);
}

 final  List<String> _topFavoriteBookIds;
@override@JsonKey() List<String> get topFavoriteBookIds {
  if (_topFavoriteBookIds is EqualUnmodifiableListView) return _topFavoriteBookIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topFavoriteBookIds);
}

@override@JsonKey() final  int followerCount;
@override@JsonKey() final  int followingCount;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.profilePicUrl, profilePicUrl) || other.profilePicUrl == profilePicUrl)&&const DeepCollectionEquality().equals(other._favoriteGenres, _favoriteGenres)&&const DeepCollectionEquality().equals(other._topFavoriteBookIds, _topFavoriteBookIds)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,displayName,bio,profilePicUrl,const DeepCollectionEquality().hash(_favoriteGenres),const DeepCollectionEquality().hash(_topFavoriteBookIds),followerCount,followingCount);

@override
String toString() {
  return 'UserModel(uid: $uid, displayName: $displayName, bio: $bio, profilePicUrl: $profilePicUrl, favoriteGenres: $favoriteGenres, topFavoriteBookIds: $topFavoriteBookIds, followerCount: $followerCount, followingCount: $followingCount)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, String displayName, String bio, String profilePicUrl, List<String> favoriteGenres, List<String> topFavoriteBookIds, int followerCount, int followingCount
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? displayName = null,Object? bio = null,Object? profilePicUrl = null,Object? favoriteGenres = null,Object? topFavoriteBookIds = null,Object? followerCount = null,Object? followingCount = null,}) {
  return _then(_UserModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,profilePicUrl: null == profilePicUrl ? _self.profilePicUrl : profilePicUrl // ignore: cast_nullable_to_non_nullable
as String,favoriteGenres: null == favoriteGenres ? _self._favoriteGenres : favoriteGenres // ignore: cast_nullable_to_non_nullable
as List<String>,topFavoriteBookIds: null == topFavoriteBookIds ? _self._topFavoriteBookIds : topFavoriteBookIds // ignore: cast_nullable_to_non_nullable
as List<String>,followerCount: null == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as int,followingCount: null == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
