import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'version.g.dart';

@JsonSerializable()
@collection
class Version {
  Version();

  final Id id = Isar.autoIncrement;
  late String collectionName;
  late int version;

  static Version? fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data();

    if (data == null) {
      return null;
    }

    return Version()
      ..collectionName = data['collectionName'] as String
      ..version = data['version'] as int;
  }

  /// Connect the generated [_$VersionFromJson] function to the `fromJson`
  /// factory.
  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);

  /// Connect the generated [_$VersionToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$VersionToJson(this);
}
