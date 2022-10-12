import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  int age;
  DateTime dateCreated;

  User(
      {this.id = '',
      required this.name,
      required this.age,
      required this.dateCreated});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'dateCreated': dateCreated,
      };

  static User fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      dateCreated: (json['dateCreated'] as Timestamp).toDate());
}
