import 'package:dimple/common/const/const.dart';
import 'package:dimple/common/dio/dio.dart';
import 'package:dimple/common/model/login_response.dart';
import 'package:dimple/user/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(baseUrl: 'https://$ip', dio: dio);
});

class AuthRepository {
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  // 소셜 로그인 시작
  Future<String> socialLogin(String provider) async {
    try {
      final resp = await dio.get(
        '$baseUrl/auth/login/$provider',
      );
      // 리다이렉션 URL을 반환
      return resp.headers.value('location') ?? '';
    } catch (e) {
      throw Exception('소셜 로그인 시작 실패: $e');
    }
  }

  // JWT 토큰 발급
  Future<LoginResponse> getToken(String token) async {
    try {
      final resp = await dio.get(
        '$baseUrl/auth/success',
        queryParameters: {'token': token},
      );
      return LoginResponse.fromJson(resp.data);
    } catch (e) {
      throw Exception('토큰 발급 실패: $e');
    }
  }

  // 로그아웃
  Future<LogoutResponse> logout(String token) async {
    try {
      final resp = await dio.post(
        '$baseUrl/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return LogoutResponse.fromJson(resp.data);
    } catch (e) {
      throw Exception('로그아웃 실패: $e');
    }
  }

  // Future<TokenResponse> token() async {
  //   final resp = await dio.post(
  //     '$baseUrl/token',
  //     options: Options(headers: {
  //       'refreshToken': 'true',
  //     }),
  //   );
  //   return TokenResponse.fromJson(resp.data);
  // }
}