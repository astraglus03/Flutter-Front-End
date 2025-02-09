// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      email: json['email'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String,
      provider: json['provider'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'profileImage': instance.profileImage,
      'provider': instance.provider,
    };

SocialLoginResponse _$SocialLoginResponseFromJson(Map<String, dynamic> json) =>
    SocialLoginResponse(
      redirectionUrl: json['redirectionUrl'] as String,
      successUrl: json['successUrl'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$SocialLoginResponseToJson(
        SocialLoginResponse instance) =>
    <String, dynamic>{
      'redirectionUrl': instance.redirectionUrl,
      'successUrl': instance.successUrl,
      'token': instance.token,
    };

LogoutResponse _$LogoutResponseFromJson(Map<String, dynamic> json) =>
    LogoutResponse(
      message: json['message'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$LogoutResponseToJson(LogoutResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
    };
