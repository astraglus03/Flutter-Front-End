import 'package:dimple/user/model/dog_model.dart';
import 'package:dimple/user/view_model/dog_repository.dart';
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

  // screen 1
  void saveBasicInfo({
    required String? image,
    required String name,
    required int age,
    required double weight,
    required String gender,
    required bool isNeutered,
    required String breed,
  }) {
    state = DogModel(
      image: image,
      name: name,
      age: age,
      weight: weight,
      gender: gender,
      isNeutered: isNeutered,
      breed: breed,
      height: 0,  // 임시값, screen2에서 업데이트됨
      legLength: 0,  // 임시값, screen2에서 업데이트됨
      bloodType: '',  // 임시값, screen2에서 업데이트됨
      registrationNumber: '',  // 임시값, screen2에서 업데이트됨
      recentCheckupDate: DateTime.now(),  // 임시값, 나중에 업데이트됨
      heartwormVaccinationDate: DateTime.now(),  // 임시값, 나중에 업데이트됨
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
  Future<DogModel> registerDog() async {
    if (state == null) {
      throw Exception('등록할 강아지 정보가 없습니다.');
    }

    try {
      // 이미지가 null인 경우 기본 이미지로 설정
      if (state!.image == null) {
        state = state!.copyWith(
          image: 'assets/img/banreou.png',
        );
      }

      print('등록할 강아지 정보:');
      print('breed: ${state!.breed}');
      print('isNeutered: ${state!.isNeutered}');
      print('gender: ${state!.gender}');
      print('id: ${state!.id}');
      print('height: ${state!.height}');
      print('bloodType: ${state!.bloodType}');
      print('name: ${state!.name}');
      print('image: ${state!.image}');
      print('recentCheckupDate: ${state!.recentCheckupDate}');
      print('legLength: ${state!.legLength}');
      print('age: ${state!.age}');
      print('menstruationCycle: ${state!.menstruationCycle}');
      print('menstruationDuration: ${state!.menstruationDuration}');
      print('menstruationStartDate: ${state!.menstruationStartDate}');

      final dog = await repository.createDog(dog: state!);
      state = dog;
      return dog;
    } catch (e) {
      print('강아지 등록 실패: $e');
      throw Exception('등록 실패: $e');
    }
  }

  // 상태 초기화
  void reset() {
    state = null;
  }
}