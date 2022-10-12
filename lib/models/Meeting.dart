import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interview_scheduler/models/User.dart';

class Meeting {
  String id;
  late String title;
  DateTime startTime;
  DateTime endTime;
  List<User> participants = [];

  Meeting({
    this.id = '',
    // this.participants,
    required this.title,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'startTime': startTime,
        'endTime': endTime,
        // 'participants': participants,
      };

  static Meeting fromJson(Map<String, dynamic> json) => Meeting(
        id: json['id'],
        title: json['title'],
        startTime: (json['startTime'] as Timestamp).toDate(),
        endTime: (json['endTime'] as Timestamp).toDate(),
        // participants: json['participants'],
      );
}
