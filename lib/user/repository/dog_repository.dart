import 'package:dimple/common/const/const.dart';
import 'package:dio/dio.dart';
import 'package:dimple/user/model/dog_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import '../../calendar/provider/calendar_provider.dart';

part 'dog_repository.g.dart';

final dogRepositoryProvider = Provider<DogRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DogRepository(dio, baseUrl: 'https://$ip');
});

@RestApi()
abstract class DogRepository {
  factory DogRepository(Dio dio, {String baseUrl}) = _DogRepository;

  @GET('/dogs')
  Future<List<DogModel>> getDogs({
    @Header('accessToken') String accessToken = 'true',
  });

  @POST('/dogs')
  Future<DogModel> createDog({
    @Header('accessToken') String accessToken = 'true',
    @Body() required DogModel dog,
  });

  @PUT('/dogs/{id}')
  Future<DogModel> updateDog({
    @Header('accessToken') String accessToken = 'true',
    @Path('id') required int id,
    @Body() required DogModel dog,
  });

  @DELETE('/dogs/{id}')
  Future<void> deleteDog({
    @Header('accessToken') String accessToken = 'true',
    @Path('id') required int id,
  });
} 