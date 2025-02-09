import 'package:dimple/common/const/const.dart';
import 'package:dimple/common/dio/dio.dart';
import 'package:dimple/user/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserMeRepository(baseUrl: 'https://$ip', dio: dio);
});

class UserMeRepository {
  final String baseUrl;
  final Dio dio;

  UserMeRepository({
    required this.baseUrl,
    required this.dio,
  });

  // 사용자 정보 조회
  Future<UserModel> getMe(String token) async {
    try {
      final resp = await dio.get(
        '$baseUrl/auth/userinfo',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return UserModel.fromJson(resp.data);
    } catch (e) {
      throw Exception('사용자 정보 조회 실패: $e');
    }
  }
}