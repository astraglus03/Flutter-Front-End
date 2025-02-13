import 'package:dimple/common/layout/default_layout.dart';
import 'package:dimple/common/view/root_tab.dart';
import 'package:dimple/common/view_model/go_router.dart';
import 'package:dimple/register/view/recent_check_screen.dart';
import 'package:dimple/user/component/menstruation_container.dart';
import 'package:dimple/user/view_model/menstruation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MenstruationDetailScreen3 extends ConsumerStatefulWidget {
  static String get routeName => '/menstruation3';
  const MenstruationDetailScreen3({super.key});

  @override
  ConsumerState<MenstruationDetailScreen3> createState() => _MenstruationDetailScreen2State();
}

class _MenstruationDetailScreen2State extends ConsumerState<MenstruationDetailScreen3> {

  int _currentValue = 30;

  @override
  Widget build(BuildContext context) {
    final menstruationInfo =ref.watch(menstruationProvider);

    return DefaultLayout(
      child: MenstruationContainer(
        title: '생리가 보통 \n며칠 지속됩니까?',
        currentValue: _currentValue,
        buttonTitle: '다음',
        onChanged: (value) {
            setState(() {
              _currentValue = value;
              ref.read(menstruationProvider.notifier).setCycleLength(_currentValue);
            });
        },
        onTap: () {
         context.goNamed(RecentCheckScreen.routeName);
        },
      ),
    );
  }
}
