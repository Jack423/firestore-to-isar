import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable()
@collection
class Person {
  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  final Id id;
  final String firstName;
  final String lastName;
  final String phone;

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
