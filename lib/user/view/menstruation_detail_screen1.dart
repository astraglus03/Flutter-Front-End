import 'package:dimple/common/component/submit_button.dart';
import 'package:dimple/common/const/colors.dart';
import 'package:dimple/user/view/menstruation_detail_screen2.dart';
import 'package:dimple/user/view_model/menstruation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

class MenstruationDetailScreen1 extends ConsumerWidget {
  const MenstruationDetailScreen1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menstruationInfo = ref.watch(menstruationProvider);
    final focusedDay = ref.watch(focusedDayProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50,),
              const Text(
                '마지막 생리 시작일이\n 언제인가요?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    TableCalendar(
                      locale:'ko_KR',
                      firstDay: DateTime.utc(2010, 1, 1),
                      lastDay: DateTime.now(),
                      focusedDay: focusedDay,
                      calendarFormat: CalendarFormat.month,
                      selectedDayPredicate: (day) {
                        return menstruationInfo.lastPeriodStartDate != null &&
                            isSameDay(menstruationInfo.lastPeriodStartDate!, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        ref.read(menstruationProvider.notifier)
                            .setLastPeriodStartDate(selectedDay);
                        ref.read(focusedDayProvider.notifier).state = focusedDay;
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          size: 24,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          size: 24,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        dowTextFormatter: (date, locale) {
                          switch (date.weekday) {
                            case DateTime.monday:
                              return '월';
                            case DateTime.tuesday:
                              return '화';
                            case DateTime.wednesday:
                              return '수';
                            case DateTime.thursday:
                              return '목';
                            case DateTime.friday:
                              return '금';
                            case DateTime.saturday:
                              return '토';
                            case DateTime.sunday:
                              return '일';
                            default:
                              return '';
                          }
                        },
                      ),
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: false,
                        selectedDecoration: const BoxDecoration(
                          color: Color(0xFFffdad7),
                        ),
                        defaultDecoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        weekendDecoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        outsideDecoration: const BoxDecoration(),
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          if (day.weekday == DateTime.saturday) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${day.day}',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ),
                            );
                          } else if (day.weekday == DateTime.sunday) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${day.day}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFffdad7),
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: SubmitButton(
                  text: '다음',
                  onPressed: menstruationInfo.lastPeriodStartDate != null
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const MenstruationDetailScreen2(),
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

