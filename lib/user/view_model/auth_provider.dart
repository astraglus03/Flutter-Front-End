import 'package:dimple/chatbot/view/chatbot_screen.dart';
import 'package:dimple/common/view/root_tab.dart';
import 'package:dimple/common/view/splash_screen.dart';
import 'package:dimple/dashboard/view/dash_board_screen.dart';
import 'package:dimple/map/view/map_page.dart';
import 'package:dimple/social/view/social_screen.dart';
import 'package:dimple/user/model/user_model.dart';
import 'package:dimple/user/view/login_screen.dart';
import 'package:dimple/user/view_model/user_me_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


final authProvider = ChangeNotifierProvider<AuthProvider>((ref){
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }){
    ref.listen<UserModelBase?>(userMeProvider, (previous,next){
      if(previous != next){
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/',
      name: 'RootTab',
      builder: (context, state) {
        return RootTab();
      },
      routes: [
        // 대시보드에 필요한 라우트
      ],
    ),
    GoRoute(
      path: '/map',
      name: 'map',
      builder: (_, state) => MapScreen(),
    ),
    GoRoute(
      path: '/chatbot',
      name: 'chatbot',
      builder: (_, state) => ChatbotScreen(),
    ),
    GoRoute(
      path: '/social',
      name: 'social',
      builder: (_, state) => SocialScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (_, state) => DashBoardScreen(),
    ),
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, __) => LoginScreen(),
    ),
  ];

  void logout(){
    ref.read(userMeProvider.notifier).logout();
  }

  String? redirectLogic(BuildContext context, GoRouterState state){
    final UserModelBase? user = ref.read(userMeProvider);

    final loginIn = state.matchedLocation =='/login';

    if(user == null){
      return loginIn ? null : '/login';
    }

    if(user is UserModel){
      return loginIn || state.matchedLocation == '/splash' ? '/' : null;
    }

    if(user is UserModelError){
      return !loginIn ? '/login' : null;
    }

    return null;

  }
}
