import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({
    required this.message,
  });
}

class UserModelLoading extends UserModelBase {}

@JsonSerializable()
class UserModel extends UserModelBase {
  final String email;
  final String name;
  final String profileImage;
  final String provider;

  UserModel({
    required this.email,
    required this.name,
    required this.profileImage,
    required this.provider,
  });

  UserModel copyWith({
    String? email,
    String? name,
    String? profileImage,
    String? provider,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      provider: provider ?? this.provider,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class LogoutResponse {
  final String message;
  final String status;

  LogoutResponse({
    required this.message,
    required this.status,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) => _$LogoutResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LogoutResponseToJson(this);
}
