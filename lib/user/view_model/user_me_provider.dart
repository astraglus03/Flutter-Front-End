import 'package:dimple/common/const/const.dart';
import 'package:dimple/common/secure_storage/secure_storage.dart';
import 'package:dimple/user/model/user_model.dart';
import 'package:dimple/user/repository/auth_repository.dart';
import 'package:dimple/user/repository/user_me_repository.dart';
import 'package:dimple/user/view_model/dog_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userMeProvider = StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userMeRepository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
    ref: ref,
    authRepository: authRepository,
    repository: userMeRepository,
    storage: storage,
  );
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final Ref ref;
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.ref,
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final token = await storage.read(key: ACCESS_TOKEN_KEY);

    if (token == null) {
      state = null;
      return;
    }

    try {
      final resp = await repository.getMe(token);
      state = resp;
    } catch (e) {
      print('사용자 정보 조회 실패: $e');
    }
  }

  // 소셜 로그인 시작
  Future<String> googleLogin() async {
    try {
      return await authRepository.googleLogin();
    } catch (e) {
      print('소셜 로그인 시작 실패: $e');
      throw Exception('소셜 로그인을 시작할 수 없습니다.');
    }
  }

  // 소셜 로그인 완료 및 토큰 처리
  Future<UserModelBase> handleSocialLoginCallback(String token) async {
    try {
      state = UserModelLoading();

      // 토큰 발급
      final resp = await authRepository.getToken(token);
      
      // 토큰 저장 전 기존 토큰 삭제
      try {
        await storage.delete(key: ACCESS_TOKEN_KEY);
        await Future.delayed(Duration(milliseconds: 100));
        await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);
      } catch (e) {
        print('토큰 저장 실패: $e');
        await storage.deleteAll();
        await Future.delayed(Duration(milliseconds: 100));
        await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);
      }

      // 사용자 정보 조회
      final userResp = await repository.getMe(resp.accessToken);
      state = userResp;

      // // 반려견 정보 조회
      // await ref.read(dogProvider.notifier).getDogs();
      
      return userResp;
    } catch (e) {
      print('로그인 처리 실패: $e');
      state = UserModelError(message: '로그인에 실패했습니다.');
      return state!;
    }
  }

  Future<void> loginWithKakao() async {
    state = UserModelLoading();

    try {
      // 1. 카카오 인증 코드 받기
      final kakaoAuthCode = await authRepository.getKakaoAuthCode();
      if (kakaoAuthCode == null) {
        state = UserModelError(message: '카카오 로그인에 실패했습니다.');
        return;
      }
      // 2. 서버에 인증 코드 전송하고 JWT 토큰 받기
      final authResp = await authRepository.authenticateWithKakao(kakaoAuthCode);

      // 기존에 저장된 토큰이 있는지 확인 후 삭제
      String? existingToken = await storage.read(key: ACCESS_TOKEN_KEY);
      if (existingToken != null) {
        await storage.delete(key: ACCESS_TOKEN_KEY);
      }

      // 3. 토큰 저장
      await storage.write(key: ACCESS_TOKEN_KEY, value: authResp.accessToken);

      // 4. 사용자 정보 가져오기
      await getMe();
    } catch (e) {
      print('로그인 실패: $e');
      state = UserModelError(message: '로그인에 실패했습니다.');
    }
  }

  Future<void> logout() async {
    try {
      // 서버 로그아웃 요청
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      if (token != null) {
        await authRepository.logout(token);
      }

      // 로컬 상태 및 저장소 초기화
      state = null;
      await storage.delete(key: ACCESS_TOKEN_KEY);
    } catch (e) {
      print('로그아웃 실패: $e');
      // 에러가 발생하더라도 로컬 데이터는 삭제
      state = null;
      await storage.delete(key: ACCESS_TOKEN_KEY);
    }
  }
}
