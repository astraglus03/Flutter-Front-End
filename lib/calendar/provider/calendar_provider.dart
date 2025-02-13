// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../model/calendar_event.dart';
// import '../repository/calendar_repository.dart';
// import '../service/calendar_service.dart';
// import '../service/mock_calendar_service.dart';
// import '../viewmodel/calendar_viewmodel.dart';
//
// final dioProvider = Provider<Dio>((ref) {
//   return Dio(BaseOptions(
//     baseUrl: AppConfig.baseUrl,
//     connectTimeout: const Duration(seconds: 5),
//     receiveTimeout: const Duration(seconds: 3),
//   ));
// });
//
// final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
//   switch (AppConfig.environment) {
//     case Environment.mock:
//       return MockCalendarRepository(MockCalendarService());
//     case Environment.production:
//       final dio = ref.watch(dioProvider);
//       return RealCalendarRepository(CalendarService(dio));
//   }
// });
//
// final calendarProvider = StateNotifierProvider<CalendarViewModel, AsyncValue<List<CalendarEvent>>>((ref) {
//   return CalendarViewModel(ref.watch(calendarRepositoryProvider));
// });