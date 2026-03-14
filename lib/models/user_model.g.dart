// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  displayName: json['displayName'] as String,
  bio: json['bio'] as String,
  profilePicUrl: json['profilePicUrl'] as String,
  favoriteGenres: (json['favoriteGenres'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'bio': instance.bio,
      'profilePicUrl': instance.profilePicUrl,
      'favoriteGenres': instance.favoriteGenres,
    };
