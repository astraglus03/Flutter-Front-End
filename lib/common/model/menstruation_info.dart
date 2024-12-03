import 'package:dimple/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

class MenstruationInfo {
  @JsonKey(
    fromJson: DataUtils.stringToDateTime,
  )
  final DateTime? lastPeriodStartDate;
  final int? periodDuration;
  final int? cycleLength;

  MenstruationInfo({
    this.lastPeriodStartDate,
    this.periodDuration,
    this.cycleLength,
  });

  MenstruationInfo copyWith({
    DateTime? lastPeriodStartDate,
    int? periodDuration,
    int? cycleLength,
  }) {
    return MenstruationInfo(
      lastPeriodStartDate: lastPeriodStartDate ?? this.lastPeriodStartDate,
      periodDuration: periodDuration ?? this.periodDuration,
      cycleLength: cycleLength ?? this.cycleLength,
    );
  }
}