import 'package:dimple/common/layout/default_layout.dart';
import 'package:dimple/register/view/recent_check_screen.dart';
import 'package:dimple/user/component/menstruation_container.dart';
import 'package:dimple/register/view_models/dog_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MenstruationDetailScreen3 extends ConsumerStatefulWidget {
  static String get routeName => '/menstruation-detail3';
  const MenstruationDetailScreen3({super.key});

  @override
  ConsumerState<MenstruationDetailScreen3> createState() => _MenstruationDetailScreen3State();
}

class _MenstruationDetailScreen3State extends ConsumerState<MenstruationDetailScreen3> {
  int _currentValue = 7;

  void _saveAndNavigate() {
    ref.read(dogRegisterProvider.notifier).saveMenstruationDuration(
      menstruationDuration: _currentValue,
    );
    context.pushNamed(RecentCheckScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: MenstruationContainer(
        title: '생리가 보통\n며칠 지속됩니까?',
        currentValue: _currentValue,
        buttonTitle: '다음',
        onChanged: (value) {
          setState(() {
            _currentValue = value;
          });
        },
        onTap: _saveAndNavigate,
      ),
    );
  }
}
