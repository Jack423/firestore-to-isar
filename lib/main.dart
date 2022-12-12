import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_to_isar/app.dart';
import 'package:firebase_to_isar/models/person.dart';
import 'package:firebase_to_isar/models/version.dart';
import 'package:firebase_to_isar/person_repository.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Don't actually set these, configure firebase correctly this was ONLY for
    // initial testing.
    options: const FirebaseOptions(
      apiKey: '...',
      appId: '...',
      messagingSenderId: '',
      projectId: '...',
    ),
  );
  final isar = await Isar.open([PersonSchema, VersionSchema]);
  final db = FirebaseFirestore.instance;
  PersonRepository personRepository = PersonRepository(
    isar: isar,
    firestore: db,
  );

  await personRepository.checkVersionWithFirestore();

  runApp(App(
    personRepository: personRepository,
  ));
}
