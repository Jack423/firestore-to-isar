import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_to_isar/models/person.dart';
import 'package:firebase_to_isar/models/version.dart';
import 'package:isar/isar.dart';

class PersonRepository {
  PersonRepository({required this.isar, required this.firestore});

  final Isar isar;
  final FirebaseFirestore firestore;
  final String versionCollection = 'versions';

  Version personCollectionVersion = Version()
    ..collectionName = 'persons'
    ..version = 0;
  List<Person> persons = List.empty();

  Version get version => personCollectionVersion;
  List<Person> get allPersons => persons;

  Future<void> checkVersionWithFirestore() async {
    final firestoreVersionSnapshot =
        await firestore.collection(versionCollection).doc('persons').get();
    Version? firestoreVersion =
        Version.fromDocumentSnapshot(firestoreVersionSnapshot);
    Version? isarVersion;

    isar.txn(() async {
      isarVersion = await isar.versions
          .filter()
          .collectionNameEqualTo('persons')
          .findFirst();
    });

    if (firestoreVersion == null || isarVersion == null) {
      final persons = await _getPersonsFromFirestore();

      await isar.writeTxn(() => isar.persons.putAll(persons));

      this.persons = persons;

      final newVersion = Version()
        ..collectionName = 'persons'
        ..version = persons.hashCode;

      personCollectionVersion = newVersion;

      await _updateFirestoreVersion(newVersion);
      await _updateIsarVersion(newVersion);
    }

    if (isarVersion?.version != firestoreVersion?.version) {
      final persons = await _getPersonsFromFirestore();

      await isar.writeTxn(() => isar.persons.putAll(persons));

      this.persons = persons;

      final newVersion = Version()
        ..collectionName = 'persons'
        ..version = persons.hashCode;

      personCollectionVersion = newVersion;

      await _updateFirestoreVersion(newVersion);
      await _updateIsarVersion(newVersion);
    }
  }

  Future<List<Person>> _getPersonsFromFirestore() async {
    final persons = await firestore.collection('persons').get();

    if (persons.docs.isEmpty) {
      return List.empty();
    }

    return persons.docs.map((doc) => Person.fromJson(doc.data())).toList();
  }

  Future<void> _updateIsarVersion(Version version) async {
    return isar.writeTxn(() async {
      await isar.versions.put(version);
    });
  }

  Future<void> _updateFirestoreVersion(Version version) async {
    await firestore
        .collection(versionCollection)
        .doc('persons')
        .set(version.toJson());
  }
}
