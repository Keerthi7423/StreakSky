// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      email: json['email'] as String?,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      subscription: json['subscription'] as String? ?? 'free',
      subExpiresAt: json['sub_expires_at'] == null
          ? null
          : DateTime.parse(json['sub_expires_at'] as String),
      timezone: json['timezone'] as String?,
      language: json['language'] as String? ?? 'en',
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'subscription': instance.subscription,
      'sub_expires_at': instance.subExpiresAt?.toIso8601String(),
      'timezone': instance.timezone,
      'language': instance.language,
    };
