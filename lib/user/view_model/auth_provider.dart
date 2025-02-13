import 'package:dimple/chatbot/view/chatbot_screen.dart';
import 'package:dimple/common/view/root_tab.dart';
import 'package:dimple/common/view/splash_screen.dart';
import 'package:dimple/dashboard/view/dash_board_screen.dart';
import 'package:dimple/map/view/map_page.dart';
import 'package:dimple/register/view/heart_worm_check_screen.dart';
import 'package:dimple/register/view/menstruation_detail_screen1.dart';
import 'package:dimple/register/view/menstruation_detail_screen2.dart';
import 'package:dimple/register/view/menstruation_detail_screen3.dart';
import 'package:dimple/register/view/recent_check_screen.dart';
import 'package:dimple/social/view/social_screen.dart';
import 'package:dimple/user/model/user_model.dart';
import 'package:dimple/register/view/dog_register_screen1.dart';
import 'package:dimple/register/view/dog_register_screen2.dart';
import 'package:dimple/user/view/login_screen.dart';
import 'package:dimple/user/view/social_login_webview_screen.dart';
import 'package:dimple/dashboard/view/temrs_screen.dart';
import 'package:dimple/user/view_model/dog_provider.dart';
import 'package:dimple/user/view_model/user_me_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/',
      name: RootTab.routeName,
      builder: (context, state) => RootTab(),
      routes: [
        GoRoute(
          path: 'terms',
          name: TermsScreen.routeName,
          builder: (_, state) => TermsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/map',
      name: MapScreen.routeName,
      builder: (_, state) => MapScreen(),
    ),
    GoRoute(
      path: '/chatbot',
      name: ChatbotScreen.routeName,
      builder: (_, state) => ChatbotScreen(),
    ),
    GoRoute(
      path: '/social',
      name: SocialScreen.routeName,
      builder: (_, state) => SocialScreen(),
    ),
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, __) => LoginScreen(),
    ),
    GoRoute(
      path: '/social-login',
      name: SocialLoginWebviewScreen.routeName,
      builder: (_, state) => SocialLoginWebviewScreen(),
    ),

    GoRoute(
      path: '/dog-register1',
      name: DogRegisterScreen1.routeName,
      builder: (_, __) => DogRegisterScreen1(),
    ),
    GoRoute(
      path: '/dog-register2',
      name: DogRegisterScreen2.routeName,
      builder: (_, __) => DogRegisterScreen2(),
    ),
    GoRoute(
      path: '/menstruation-detail1',
      name: MenstruationDetailScreen1.routeName,
      builder: (_, __) => MenstruationDetailScreen1(),
    ),
    GoRoute(
      path: '/menstruation-detail2',
      name: MenstruationDetailScreen2.routeName,
      builder: (_, __) => MenstruationDetailScreen2(),
    ),
    GoRoute(
      path: '//menstruation-detail3',
      name: MenstruationDetailScreen3.routeName,
      builder: (_, __) => MenstruationDetailScreen3(),
    ),
    GoRoute(
      path: '/recentCheck',
      name: RecentCheckScreen.routeName,
      builder: (_, __) => RecentCheckScreen(),
    ),
    GoRoute(
      path: '/heartWormCheck',
      name: HeartWormCheckScreen.routeName,
      builder: (_, __) => HeartWormCheckScreen(),
    ),
  ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);
    final currentPath = state.matchedLocation;

    // 소셜 로그인 중에는 리다이렉트 하지 않음
    if (currentPath.startsWith('/social-login')) {
      return null;
    }

    // 로딩 중에는 스플래시 화면으로
    if (user is UserModelLoading) {
      return currentPath == '/splash' ? null : '/splash';
    }

    // 로그인 성공 상태
    if (user is UserModel) {
      // 스플래시 화면에 있으면 다음 화면으로
      if (currentPath == '/splash') {
        try {
          final dogs = ref.read(dogProvider);
          // 반려견 정보가 없으면 등록 화면으로
          if (dogs == null || dogs.isEmpty) {
            return '/dog-register1';
          }
          // 반려견 정보가 있으면 홈으로
          return '/';
        } catch (e) {
          print('강아지 프로바이어 error: $e');
          return '/dog-register1';
        }
      }

      // 강아지 등록 플로우 중에는 리다이렉트 하지 않음
      if (currentPath.startsWith('/dog-register') ||
          currentPath.startsWith('/menstruation') ||
          currentPath == '/recentCheck' ||
          currentPath == '/heartWormCheck') {
        return null;
      }

      try {
        final dogs = ref.read(dogProvider);
        // 반려견 정보가 없고 등록 플로우 중이 아닐 때만 등록 화면으로
        if ((dogs == null || dogs.isEmpty) &&
            !currentPath.startsWith('/dog-register') &&
            !currentPath.startsWith('/menstruation') &&
            currentPath != '/recentCheck' &&
            currentPath != '/heartWormCheck') {
          return '/dog-register1';
        }

        // 로그인 화면에 있으면 홈으로
        if (currentPath == '/login') {
          return '/';
        }
      } catch (e) {
        print('강아지 프로바이더 error: $e');
        return currentPath == '/dog-register1' ? null : '/dog-register1';
      }

      // 스플래시 화면이나 로그인 화면에 있으면 홈으로
      if (currentPath == '/splash' || currentPath == '/login') {
        return '/';
      }

      return null;
    }

    // 로그인이 필요한 상태
    if (user == null || user is UserModelError) {
      // 스플래시 화면에서는 로그인 화면으로
      if (currentPath == '/splash') {
        return '/login';
      }
      return currentPath == '/login' ? null : '/login';
    }

    return null;
  }
}