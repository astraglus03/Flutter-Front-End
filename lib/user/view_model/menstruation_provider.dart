import 'package:dimple/common/model/menstruation_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menstruationProvider = StateNotifierProvider<MenstruationNotifier, MenstruationInfo>((ref) {
  return MenstruationNotifier();
});

class MenstruationNotifier extends StateNotifier<MenstruationInfo> {
  MenstruationNotifier() : super(MenstruationInfo());

  // 마지막 생리 날짜
  void setLastPeriodStartDate(DateTime date) {
    state = state.copyWith(lastPeriodStartDate: date);
  }

  // 생리 지속 날짜
  void setPeriodDuration(int duration) {
    state = state.copyWith(periodDuration: duration);
  }

  // 생리 주기 날짜
  void setCycleLength(int length) {
    state = state.copyWith(cycleLength: length);
  }
}