import 'package:dimple/common/const/const.dart';
import 'package:dimple/common/dio/dio.dart';
import 'package:dimple/common/model/login_response.dart';
import 'package:dimple/user/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

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

  // 구글 로그인
  Future<String> googleLogin() async {
    try {
      final resp = await dio.get(
        '$baseUrl/auth/login/google',
      );
      // 리다이렉션 URL을 반환
      return resp.headers.value('location') ?? '';
    } catch (e) {
      throw Exception('소셜 로그인 시작 실패: $e');
    }
  }

  // 카카오 로그인 및 인증 코드 받기
  Future<String> getKakaoAuthCode() async {
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      return token.accessToken;
    } catch (error) {
      print('카카오 인증 에러: $error');
      throw Exception('카카오 에러');
    }
  }

  // 서버에 카카오 인증 코드 전송하고 JWT 토큰 받기
  Future<LoginResponse> authenticateWithKakao(String kakaoAuthCode) async {
    final resp = await dio.post(
      '$baseUrl/auth/login/kakao',
      data: {
        'token': kakaoAuthCode,
      },
    );
    return LoginResponse.fromJson(resp.data);
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
}