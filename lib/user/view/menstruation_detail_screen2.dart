import 'package:dimple/common/layout/default_layout.dart';
import 'package:dimple/user/component/menstruation_container.dart';
import 'package:dimple/user/view/menstruation_detail_screen3.dart';
import 'package:dimple/user/view_model/menstruation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenstruationDetailScreen2 extends ConsumerStatefulWidget {
  const MenstruationDetailScreen2({super.key});

  @override
  ConsumerState<MenstruationDetailScreen2> createState() => _MenstruationDetailScreen2State();
}

class _MenstruationDetailScreen2State extends ConsumerState<MenstruationDetailScreen2> {

  int _currentValue = 7;

  @override
  Widget build(BuildContext context) {
    final menstruationInfo = ref.watch(menstruationProvider);

    return DefaultLayout(
      child: MenstruationContainer(
        title: '주기길이가 보통\n어떻게 됩니까?',
        currentValue: _currentValue,
        buttonTitle: '댜음',
        onChanged: (value){
          setState(() {
            _currentValue = value;
            ref.read(menstruationProvider.notifier).setPeriodDuration(_currentValue);
          });
        },
        onTap: (){
          menstruationInfo.periodDuration !=null ?  Navigator.of(context).push(MaterialPageRoute(builder: (_) => MenstruationDetailScreen3())): null;
        },
      ),
    );
  }
}
