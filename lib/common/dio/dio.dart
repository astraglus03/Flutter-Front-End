import 'package:dimple/common/const/const.dart';
import 'package:dimple/common/secure_storage/secure_storage.dart';
import 'package:dimple/user/view_model/user_me_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dimple/user/view_model/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);
  dio.interceptors.add(CustomInterceptor(storage: storage, ref: ref));

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');
    
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      
      if (token != null) {
        options.headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }
    }

    return super.onRequest(options, handler);
  }

  // 2) 요청을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    
    // JWT 토큰이 응답에 포함된 경우 저장
    if (response.data is Map<String, dynamic> && 
        response.data['token'] != null) {
      storage.write(key: ACCESS_TOKEN_KEY, value: response.data['token']);
    }
    
    super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    print('Error details: ${err.message}');
    print('Error response: ${err.response?.data}');

    // 401 에러 처리
    if (err.response?.statusCode == 401) {
      await storage.delete(key: ACCESS_TOKEN_KEY);
      ref.read(userMeProvider.notifier).logout();
    }

    super.onError(err, handler);
  }

  // void onError(DioException err, ErrorInterceptorHandler handler) async {
  //   print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
  //
  //   final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
  //
  //   // refreshToken이 없을때 에러를 던짐
  //   if (refreshToken == null) {
  //     // error 던질때 handler.reject 사용
  //     return handler.reject(err);
  //   }
  //
  //   final isStatus401 = err.response?.statusCode == 401;
  //   final isPathRefresh = err.requestOptions.path == '/auth/token';
  //
  //   if (isStatus401 && !isPathRefresh) {
  //     final dio = Dio();
  //
  //     try {
  //       final resp = await dio.post('http://$ip/auth/token',
  //           options:
  //           Options(headers: {'authorization': 'Bearer $refreshToken'}));
  //       final accessToken = resp.data['accessToken'];
  //       final options = err.requestOptions;
  //
  //       // 토큰 변경
  //       options.headers.addAll({'authorization': 'Bearer $accessToken'});
  //       await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
  //
  //       // 요청 재전송
  //       final response = await dio.fetch(options);
  //
  //       return handler.resolve(response);
  //     } on DioError catch (e) {
  //       ref.read(authProvider.notifier).logout();
  //     }
  //   }
  //
  //   // TODO: implement onError
  //   super.onError(err, handler);
  // }
}
