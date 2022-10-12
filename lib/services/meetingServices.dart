import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:interview_scheduler/Components/MeetingCard.dart';
import 'package:interview_scheduler/models/Meeting.dart';
import 'package:interview_scheduler/models/User.dart';

Future createMeeting(Meeting meeting) async {
  final docMeeting = FirebaseFirestore.instance.collection('Meetings').doc();

  meeting.id = docMeeting.id;

  final json = meeting.toJson();

  await docMeeting.set(json);
}

Stream<List<Meeting>> readMeetings() {
  return FirebaseFirestore.instance.collection('Meetings').snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Meeting.fromJson(doc.data())).toList());
}

Widget buildMeeting(Meeting meeting) {
  return MeetingCard(meeting: meeting);
}
