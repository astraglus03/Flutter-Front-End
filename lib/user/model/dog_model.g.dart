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
      isNeutered: json['isNeutered'] as bool,
      breed: json['puppySpecies'] as String,
      height: (json['height'] as num).toInt(),
      legLength: (json['legLength'] as num).toInt(),
      bloodType: json['bloodType'] as String,
      registrationNumber: json['registrationNumber'] as String,
      recentCheckupDate: DateTime.parse(json['recentCheckupDate'] as String),
      heartwormVaccinationDate:
          DateTime.parse(json['heartwormVaccinationDate'] as String),
      image: json['image'] as String?,
      menstruationStartDate: json['menstruationStartDate'] == null
          ? null
          : DateTime.parse(json['menstruationStartDate'] as String),
      menstruationCycle: (json['menstruationCycle'] as num?)?.toInt(),
      menstruationDuration: (json['menstruationDuration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DogModelToJson(DogModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'weight': instance.weight,
      'gender': instance.gender,
      'isNeutered': instance.isNeutered,
      'puppySpecies': instance.breed,
      'height': instance.height,
      'legLength': instance.legLength,
      'bloodType': instance.bloodType,
      'registrationNumber': instance.registrationNumber,
      'recentCheckupDate': instance.recentCheckupDate.toIso8601String(),
      'heartwormVaccinationDate':
          instance.heartwormVaccinationDate.toIso8601String(),
      'image': instance.image,
      'menstruationStartDate':
          instance.menstruationStartDate?.toIso8601String(),
      'menstruationCycle': instance.menstruationCycle,
      'menstruationDuration': instance.menstruationDuration,
    };
