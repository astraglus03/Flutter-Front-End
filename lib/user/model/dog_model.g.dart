// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DogModel _$DogModelFromJson(Map<String, dynamic> json) => DogModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      gender: json['gender'] as String,
      breed: json['puppySpecies'] as String,
      height: (json['height'] as num).toInt(),
      legLength: (json['legLength'] as num).toInt(),
      bloodType: json['bloodType'] as String,
      registrationNumber: json['registrationNumber'] as String,
      image: json['image'] as String?,
      lastMenstruation: json['lastMenstruation'] == null
          ? null
          : DateTime.parse(json['lastMenstruation'] as String),
      menstruationCycle: (json['menstruationCycle'] as num?)?.toInt(),
      menstruationDuration: (json['menstruationDuration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DogModelToJson(DogModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'weight': instance.weight,
      'gender': instance.gender,
      'puppySpecies': instance.breed,
      'height': instance.height,
      'legLength': instance.legLength,
      'bloodType': instance.bloodType,
      'registrationNumber': instance.registrationNumber,
      'image': instance.image,
      'lastMenstruation': instance.lastMenstruation?.toIso8601String(),
      'menstruationCycle': instance.menstruationCycle,
      'menstruationDuration': instance.menstruationDuration,
    };
