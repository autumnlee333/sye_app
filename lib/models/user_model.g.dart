// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  displayName: json['displayName'] as String,
  username: json['username'] as String,
  bio: json['bio'] as String,
  profilePicUrl: json['profilePicUrl'] as String,
  favoriteGenres: (json['favoriteGenres'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  topFavoriteBookIds:
      (json['topFavoriteBookIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  followerCount: (json['followerCount'] as num?)?.toInt() ?? 0,
  followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'username': instance.username,
      'bio': instance.bio,
      'profilePicUrl': instance.profilePicUrl,
      'favoriteGenres': instance.favoriteGenres,
      'topFavoriteBookIds': instance.topFavoriteBookIds,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
    };
