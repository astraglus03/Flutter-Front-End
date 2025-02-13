import 'package:json_annotation/json_annotation.dart';

part 'dog_model.g.dart';

@JsonSerializable()
class DogModel {
  final int? id;
  final String name;
  final int age;
  final double weight;
  final String gender;
  final bool isNeutered;
  @JsonKey(name: 'puppySpecies')
  final String breed;
  final int height;
  @JsonKey(name: 'legLength')
  final int legLength;
  @JsonKey(name: 'bloodType')
  final String bloodType;
  @JsonKey(name: 'registrationNumber')
  final String registrationNumber;
  final DateTime recentCheckupDate;
  final DateTime heartwormVaccinationDate;
  final String? image;
  @JsonKey(name: 'menstruationStartDate')
  final DateTime? menstruationStartDate;
  @JsonKey(name: 'menstruationCycle')
  final int? menstruationCycle;
  @JsonKey(name: 'menstruationDuration')
  final int? menstruationDuration;

  DogModel({
    this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.gender,
    required this.isNeutered,
    required this.breed,
    required this.height,
    required this.legLength,
    required this.bloodType,
    required this.registrationNumber,
    required this.recentCheckupDate,
    required this.heartwormVaccinationDate,
    this.image,
    this.menstruationStartDate,
    this.menstruationCycle,
    this.menstruationDuration,
  });

  factory DogModel.fromJson(Map<String, dynamic> json) => _$DogModelFromJson(json);
  Map<String, dynamic> toJson() => _$DogModelToJson(this);

  DogModel copyWith({
    int? id,
    String? name,
    int? age,
    double? weight,
    String? gender,
    bool? isNeutered,
    String? breed,
    int? height,
    int? legLength,
    String? bloodType,
    String? registrationNumber,
    DateTime? recentCheckupDate,
    DateTime? heartwormVaccinationDate,
    String? image,
    DateTime? menstruationStartDate,
    int? menstruationCycle,
    int? menstruationDuration,
  }) {
    return DogModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      isNeutered : isNeutered ?? this.isNeutered,
      breed: breed ?? this.breed,
      height: height ?? this.height,
      legLength: legLength ?? this.legLength,
      bloodType: bloodType ?? this.bloodType,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      recentCheckupDate : recentCheckupDate ?? this.recentCheckupDate,
      heartwormVaccinationDate : heartwormVaccinationDate ?? this.heartwormVaccinationDate,
      image: image ?? this.image,
      menstruationStartDate: menstruationStartDate ?? this.menstruationStartDate,
      menstruationCycle: menstruationCycle ?? this.menstruationCycle,
      menstruationDuration: menstruationDuration ?? this.menstruationDuration,
    );
  }
} 