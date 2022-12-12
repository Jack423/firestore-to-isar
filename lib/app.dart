import 'package:firebase_to_isar/person_repository.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key, required this.personRepository});

  final PersonRepository personRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firestore to Isar Example'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Version',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(personRepository.version.version.toString()),
              SizedBox(height: 16),
              Text(
                'People',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Column(
                children: personRepository.allPersons
                    .map((person) => Card(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Text('${person.firstName} ${person.lastName}'),
                                Text(person.phone)
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
