import 'package:json_annotation/json_annotation.dart';

part 'dog_model.g.dart';

@JsonSerializable()
class DogModel {
  final int? id;
  final String name;
  final int age;
  final double weight;
  final String gender;
  @JsonKey(name: 'puppySpecies')
  final String breed;
  final int height;
  @JsonKey(name: 'legLength')
  final int legLength;
  @JsonKey(name: 'bloodType')
  final String bloodType;
  @JsonKey(name: 'registrationNumber')
  final String registrationNumber;
  final String? image;
  @JsonKey(name: 'lastMenstruation')
  final DateTime? lastMenstruation;
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
    required this.breed,
    required this.height,
    required this.legLength,
    required this.bloodType,
    required this.registrationNumber,
    this.image,
    this.lastMenstruation,
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
    String? breed,
    int? height,
    int? legLength,
    String? bloodType,
    String? registrationNumber,
    String? image,
    DateTime? lastMenstruation,
    int? menstruationCycle,
    int? menstruationDuration,
  }) {
    return DogModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      breed: breed ?? this.breed,
      height: height ?? this.height,
      legLength: legLength ?? this.legLength,
      bloodType: bloodType ?? this.bloodType,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      image: image ?? this.image,
      lastMenstruation: lastMenstruation ?? this.lastMenstruation,
      menstruationCycle: menstruationCycle ?? this.menstruationCycle,
      menstruationDuration: menstruationDuration ?? this.menstruationDuration,
    );
  }
} 