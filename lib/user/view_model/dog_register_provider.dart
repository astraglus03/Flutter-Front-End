import 'package:dimple/user/model/dog_model.dart';
import 'package:dimple/user/repository/dog_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dogRegisterProvider = StateNotifierProvider<DogRegisterNotifier, DogModel?>((ref) {
  final repository = ref.watch(dogRepositoryProvider);
  return DogRegisterNotifier(repository: repository);
});

class DogRegisterNotifier extends StateNotifier<DogModel?> {
  final DogRepository repository;

  DogRegisterNotifier({
    required this.repository,
  }) : super(null);

  void saveBasicInfo({
    required String? image,
    required String name,
    required int age,
    required double weight,
    required String gender,
    required bool isNeutered,
    required String breed,
  }) {
    state = state!.copyWith(
      image: image,
      name: name,
      age: age,
      weight: weight,
      gender: gender,
      isNeutered: isNeutered,
      breed: breed,
    );
  }

  // Screen 2
  void saveAdditionalInfo({
    required int height,
    required int legLength,
    required String bloodType,
    required String registrationNumber,
  }) {
    if (state == null) return;

    state = state!.copyWith(
      height: height,
      legLength: legLength,
      bloodType: bloodType,
      registrationNumber: registrationNumber,
    );
  }

  // Menstruation Screen 1
  void saveMenstruationStartDate({
    required DateTime menstruationStartDate,
  }) {
    if (state == null) return;

    state = state!.copyWith(
      menstruationStartDate: menstruationStartDate,
    );
  }

  // Menstruation Screen 2
  void saveMenstruationCycle({
    required int menstruationCycle,
  }) {
    if (state == null) return;

    state = state!.copyWith(
      menstruationCycle: menstruationCycle,
    );
  }

  // Menstruation Screen 3
  void saveMenstruationDuration({
    required int menstruationDuration,
  }) {
    if (state == null) return;

    state = state!.copyWith(
      menstruationDuration: menstruationDuration,
    );
  }

  // Health Check Screen 1
  void saveHealthCheckDate({
    required DateTime recentCheckupDate,
  }) {
    if (state == null) return;

    state = state!.copyWith(
      recentCheckupDate: recentCheckupDate,
    );
  }

  // Health Check Screen 2
  void saveHeartWormVaccinationDate({
    required DateTime heartwormVaccinationDate,
  }) {
    if (state == null) return;

    state = state!.copyWith(
      heartwormVaccinationDate: heartwormVaccinationDate,
    );
  }

  // 강아지 등록 및 루트 탭으로 이동
  Future<DogModel?> registerDog() async {
    if (state == null) return null;

    try {
      final dog = await repository.createDog(dog: state!);
      state = dog;
      return dog;
    } catch (e) {
      print('강아지 등록 실패: $e');
      return null;
    }
  }

  // 상태 초기화
  void reset() {
    state = null;
  }
}