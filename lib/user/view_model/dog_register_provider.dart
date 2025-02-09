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

  // 기본 정보 저장 (Screen1)
  void saveBasicInfo({
    required String name,
    required int age,
    required double weight,
    required String gender,
    required String breed,
    required int height,
    required int legLength,
  }) {
    state = DogModel(
      name: name,
      age: age,
      weight: weight,
      gender: gender,
      breed: breed,
      height: height,
      legLength: legLength,
      bloodType: '',  // Screen2에서 입력
      registrationNumber: '',  // Screen2에서 입력
    );
  }

  // 추가 정보 저장 (Screen2)
  void saveAdditionalInfo({
    required String bloodType,
    required String registrationNumber,
    String? image,
  }) {
    if (state == null) return;
    
    state = state!.copyWith(
      bloodType: bloodType,
      registrationNumber: registrationNumber,
      image: image,
    );
  }

  // 생리 정보 저장 (MenstruationScreen)
  void saveMenstruationInfo({
    required DateTime lastMenstruation,
    required int menstruationCycle,
    required int menstruationDuration,
  }) {
    if (state == null) return;
    
    state = state!.copyWith(
      lastMenstruation: lastMenstruation,
      menstruationCycle: menstruationCycle,
      menstruationDuration: menstruationDuration,
    );
  }

  // 강아지 등록
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