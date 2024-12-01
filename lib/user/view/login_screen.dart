import 'package:dimple/common/const/colors.dart';
import 'package:dimple/common/const/const.dart';
import 'package:dimple/user/model/user_model.dart';
import 'package:dimple/user/view_model/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => '/login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userMeProvider);

    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 177,),
            Container(
              child: Column(
                children: [
                  Image.asset('assets/img/banreou.png', width: 200, height: 200,),
                ],
              ),
            ),
            const SizedBox(height: 181,),
            GestureDetector(child: Image.asset('assets/img/male_icon.png',  width: 336, height: 56,),
              onTap: state is UserModelLoading ? null : () async{
              ref.read(userMeProvider.notifier).login(clientId: clientId, redirectUri: redirectUri,kaKaoAuthUrl: kaKaoAuthUrl);
              }
            ),
            const SizedBox(height: 18,),
            GestureDetector(child: Image.asset('assets/img/female_icon.png',  width: 336, height: 56,),
                onTap: state is UserModelLoading ? null : () async{
                  ref.read(userMeProvider.notifier).login(clientId: clientId, redirectUri: redirectUri,kaKaoAuthUrl: kaKaoAuthUrl);
                }
            ),
          ],

        ),
      ),
    );
  }
}
