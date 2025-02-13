import 'package:dimple/common/const/colors.dart';
import 'package:dimple/common/const/const.dart';
import 'package:dimple/common/view/root_tab.dart';
import 'package:dimple/user/model/user_model.dart';
import 'package:dimple/user/view/social_login_webview_screen.dart';
import 'package:dimple/user/view_model/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  static String get routeName => '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userMeProvider);

    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 177),
            Image.asset(
              'assets/img/banreou.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 181),
            GestureDetector(
              onTap: state is UserModelLoading
                  ? null
                  : () => context.pushNamed(SocialLoginWebviewScreen.routeName,),
              child: Image.asset('assets/img/google_login_logo.png'),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: state is UserModelLoading
                  ? null
                  : () => ref.read(userMeProvider.notifier).loginWithKakao(),
              child: Image.asset('assets/img/kakao_login_logo.png'),
            ),
            if (state is UserModelLoading)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
