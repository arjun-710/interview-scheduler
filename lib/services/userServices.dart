import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/User.dart';
// import 'package:interview_scheduler/models/User.dart';
// import './models/User.dart';

// Future createUser({required String name}) async {
//       final docUser = FirebaseFirestore.instance.collection('Users').doc();

//       final user = User(
//         id: docUser.id,
//         name: name,
//         age: 21,
//         dateCreated: DateTime.now(),
//       );

//       final json = user.toJson();
//       await docUser.set(json);
//     }

Future createUser(User user) async {
  final docUser = FirebaseFirestore.instance.collection('Users').doc();

  user.id = docUser.id;

  final json = user.toJson();
  await docUser.set(json);
}

Stream<List<User>> readUsers() {
  return FirebaseFirestore.instance.collection('Users').snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
}

Widget buildUser(User user) {
  return ListTile(
      leading: CircleAvatar(child: Text('${user.age}')),
      title: Text(user.name),
      subtitle: Text(user.dateCreated.toIso8601String()));
}
