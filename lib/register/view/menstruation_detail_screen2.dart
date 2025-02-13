import 'package:dimple/common/layout/default_layout.dart';
import 'package:dimple/user/component/menstruation_container.dart';
import 'package:dimple/register/view/menstruation_detail_screen3.dart';
import 'package:dimple/register/view_models/dog_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MenstruationDetailScreen2 extends ConsumerStatefulWidget {
  static String get routeName => '/menstruation-detail2';

  const MenstruationDetailScreen2({super.key});

  @override
  ConsumerState<MenstruationDetailScreen2> createState() =>
      _MenstruationDetailScreen2State();
}

class _MenstruationDetailScreen2State
    extends ConsumerState<MenstruationDetailScreen2> {
  int _currentValue = 30;

  void _saveAndNavigate() {
    ref.read(dogRegisterProvider.notifier).saveMenstruationCycle(
      menstruationCycle: _currentValue,
    );
    context.pushNamed(MenstruationDetailScreen3.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: MenstruationContainer(
        title: '주기길이가 보통\n어떻게 됩니까?',
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
