import 'package:dimple/chatbot/view/chatbot_screen.dart';
import 'package:dimple/common/const/api_keys.dart';
import 'package:dimple/common/view/root_tab.dart';
import 'package:dimple/common/view_model/go_router.dart';
import 'package:dimple/register/view/dog_register_screen1.dart';
import 'package:dimple/user/view/login_screen.dart';
import 'package:dimple/register/view/menstruation_detail_screen1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  await initializeDateFormatting();

  // 실제 서버 사용시
  // AppConfig.environment = Environment.production;
  KakaoSdk.init(nativeAppKey: ApiKeys.kakaoNativeAppKey,);
  WidgetsFlutterBinding.ensureInitialized();
  // 가로모드로 하게되면 심각한 overflow와 폰트, 깨짐. 모든 반은형으로 하기전까지 코드 필수.
  SystemChrome.setPreferredOrientations(([
    DeviceOrientation.portraitUp
  ]));
  initializeDateFormatting('ko_KR').then((_) => runApp(ProviderScope(child:MyApp())));
}

class MyApp extends ConsumerWidget {


  const MyApp({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final router = ref.watch(routerProvider);
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,  // 텍스트 크기 자동 조정
      splitScreenMode: true,  // 분할 화면 모드
      child:  MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          ),
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: LoginScreen(),
    // );
  }
}