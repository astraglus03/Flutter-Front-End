import 'package:dimple/user/model/dog_model.dart';
import 'package:dimple/user/repository/dog_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dogProvider = StateNotifierProvider<DogStateNotifier, List<DogModel>?>((ref) {
  final repository = ref.watch(dogRepositoryProvider);
  final notifier = DogStateNotifier(repository: repository);
  return notifier;
});

class DogStateNotifier extends StateNotifier<List<DogModel>?> {
  final DogRepository repository;

  DogStateNotifier({
    required this.repository,
  }) : super(null);

  Future<List<DogModel>> getDogs() async {
    try {
      final dogs = await repository.getDogs();
      state = dogs;
      return dogs;
    } catch (e) {
      print('반려견 정보 조회 실패: $e');
      state = [];
      return [];
    }
  }
} 