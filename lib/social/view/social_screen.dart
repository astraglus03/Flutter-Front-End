import 'package:dimple/user/view_model/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialScreen extends ConsumerWidget {
  static String get routeName => 'social';

  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userMeProvider);
    return Center(
      child: Center(
        child: TextButton(
          onPressed: () {
            ref.read(userMeProvider.notifier).logout();
          },
          child: Text('로그아웃'),
        ),
      ),
    );
  }
}
