import 'dart:math';
import 'package:dimple/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/calendar_event.dart';
import '../provider/calendar_provider.dart';
import 'widgets/add_event_bottom_sheet.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  static String get routeName => 'calendar';
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(calendarProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('캘린더', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          _buildProfileSection(),
          _buildCalendar(eventsState),
          _buildEventList(eventsState),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Chip(
                avatar: const CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                label: const Text('마루'),
                backgroundColor: Colors.amber.shade200,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(AsyncValue<List<CalendarEvent>> eventsState) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _focusedDay = DateTime(
                          _focusedDay.year - 1,
                          _focusedDay.month,
                        );
                      });
                      ref.read(calendarProvider.notifier).updateFocusedDay(_focusedDay);
                    },
                    child: Text('<<', 
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 16)
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _focusedDay = DateTime(
                          _focusedDay.year,
                          _focusedDay.month - 1,
                        );
                      });
                      ref.read(calendarProvider.notifier).updateFocusedDay(_focusedDay);
                    },
                    child: Text('<', 
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 16)
                    ),
                  ),
                ],
              ),
              Text(
                '${_focusedDay.year}년 ${_focusedDay.month}월',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _focusedDay = DateTime(
                          _focusedDay.year,
                          _focusedDay.month + 1,
                        );
                      });
                      ref.read(calendarProvider.notifier).updateFocusedDay(_focusedDay);
                    },
                    child: Text('>', 
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 16)
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _focusedDay = DateTime(
                          _focusedDay.year + 1,
                          _focusedDay.month,
                        );
                      });
                      ref.read(calendarProvider.notifier).updateFocusedDay(_focusedDay);
                    },
                    child: Text('>>', 
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 16)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              width: 1,
              color: CALENDAR_SLICER_COLOR
            ),
          ),
          child: eventsState.when(
            loading: () => const CircularProgressIndicator(),
            error: (err, st) => Text('에러 발생: $err'),
            data: (events) => TableCalendar(
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 0),
                headerMargin: EdgeInsets.zero,
                leftChevronVisible: false,
                rightChevronVisible: false,
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                defaultTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                weekendTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                outsideTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade300,
                ),
                selectedTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                todayTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                holidayTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                todayDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                markerDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                cellMargin: EdgeInsets.zero,
                cellPadding: EdgeInsets.zero,
                cellAlignment: Alignment.topRight,
              ),
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  const days = ['일', '월', '화', '수', '목', '금', '토'];
                  final text = days[day.weekday % 7];
                  return Stack( 
                    children: [
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.only(right: 8, bottom: 4),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // 하단 구분선만 남기고 우측 구분선 제거
                      Positioned(
                        left: 8,
                        right: 8,
                        bottom: 0,
                        child: Container(
                          height: 1,
                          color: CALENDAR_SLICER_COLOR,
                        ),
                      ),
                    ],
                  );
                },
                defaultBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, events);
                },
                outsideBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, events, isOutside: true);
                },
              ),
              daysOfWeekHeight: 40,
              rowHeight: 60,
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {
                CalendarFormat.month: '',
              },
              eventLoader: (day) {
                return events.where((event) => isSameDay(event.date, day)).toList();
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                ref.read(calendarProvider.notifier).updateFocusedDay(focusedDay);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventList(AsyncValue<List<CalendarEvent>> eventsState) {
    return eventsState.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, st) => Text('에러 발생: $err'),
      data: (events) {
        final selectedEvents = events
            .where((event) => isSameDay(event.date, _selectedDay))
            .toList();

        return Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedDay.month}월 ${_selectedDay.day}일',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _showAddEventBottomSheet,
                      icon: const Icon(Icons.add),
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedEvents.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final event = selectedEvents[index];
                    return _buildEventTile(event);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventTile(CalendarEvent event) {
    Color backgroundColor;
    String title;

    switch (event.type) {
      case EventType.vaccination:
        backgroundColor = Colors.pink.shade100;
        title = '예방접종';
        break;
      case EventType.hospital:
        backgroundColor = Colors.blue.shade100;
        title = '병원내원';
        break;
      case EventType.period:
        backgroundColor = Colors.red.shade100;
        title = '월경';
        break;
      case EventType.fertile:
        backgroundColor = Colors.purple.shade100;
        title = '가임기';
        break;
    }

    return Dismissible(
      key: ObjectKey(event),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(calendarProvider.notifier).deleteEvent(event);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (event.count != null)
              Text('${event.count}회차'),
            if (event.description != null) ...[
              const SizedBox(width: 8),
              Expanded(child: Text(event.description!)),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddEventBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddEventBottomSheet(
          selectedDate: _selectedDay,
          onEventAdded: (event) {
            ref.read(calendarProvider.notifier).addEvent(event);
          },
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime day, List<CalendarEvent> events, {bool isOutside = false}) {
    final eventsList = events.where((event) => isSameDay(event.date, day)).toList();

    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 20,
                padding: const EdgeInsets.only(top: 4),
                margin: const EdgeInsets.only(right: 8),
                alignment: Alignment.centerRight,
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isOutside ? Colors.grey.shade300 : Colors.grey.shade600,
                  ),
                ),
              ),
              if (eventsList.isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(top: 2, right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      min(eventsList.length, 4),
                      (index) => Container(
                        margin: const EdgeInsets.only(left: 2),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.amber.shade200,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              const Spacer(),
            ],
          ),
        ),
        Positioned(
          left: 8,
          right: 8,
          bottom: 0,
          child: Container(
            height: 1,
            color: CALENDAR_SLICER_COLOR,
          ),
        ),
      ],
    );
  }
} 