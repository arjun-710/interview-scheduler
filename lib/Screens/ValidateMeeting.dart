import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interview_scheduler/Components/CustomText.dart';
import 'package:interview_scheduler/Components/ListParticipants.dart';
import 'package:interview_scheduler/Components/ShowSnackBar.dart';
import 'package:interview_scheduler/Screens/Layout.dart';
import 'package:interview_scheduler/constants.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ValidateMeeting extends StatelessWidget {
  final DateTime startTimeStamp;
  final DateTime endTimeStamp;
  final Set invalidParts;
  final List selectedParts;
  final String title;
  const ValidateMeeting(
      {Key? key,
      required this.startTimeStamp,
      required this.endTimeStamp,
      required this.invalidParts,
      required this.selectedParts,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List common = [];
    List mailingList = [];

    void sendMessage() async {
      final Email email = Email(
        body:
            'hello meeting fixed from ${startTimeStamp.toIso8601String()} to ${endTimeStamp.toIso8601String()} ',
        subject: 'A meeting for $title',
        recipients: selectedParts.map((e) => e['email'].toString()).toList(),
        isHTML: false,
      );
      try {
        await FlutterEmailSender.send(email);
      } catch (e) {
        log(e.toString());
        // showSnackBar(context, e.toString());
      }
      showSnackBar(context, "Mails send");
    }

    for (int i = 0; i < selectedParts.length; i++) {
      if (invalidParts
          .where((element) => element['id'] == selectedParts[i]['id'])
          .isNotEmpty) {
        common.add(selectedParts[i]);
      }
    }

    // print(invalidParts);
    // print(selectedParts);
    // print(common);
    // print(selectedParts);
    if (common.isEmpty) {
      try {
        final docMeeting =
            FirebaseFirestore.instance.collection('Meetings').doc();
        var meeting = {
          'id': docMeeting.id,
          'startTime': startTimeStamp,
          'endTime': endTimeStamp,
          'participants': selectedParts,
          'title': title,
        };

        docMeeting.set(meeting);

        // Navigator.pop(context);

        sendMessage();
        Navigator.pushNamed(context, '/landing');
        // showSnackBar(context, "Meeting created");

        // Navigator.pushNamedAndRemoveUntil(
        //     context, "/landing", (Route<dynamic> route) => false);
        // Navigator.popUntil(context, (route) => false);
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //     '/landing', (Route<dynamic> route) => false);

      } catch (e) {
        log(e.toString());
        // showSnackBar(context, e.toString());
      }
    } else if (common.isNotEmpty) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Layout(
            pageText: "Validation",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(text: "Unavailable Participants"),
                const SizedBox(height: 40),
                ListParticipants(
                  size: MediaQuery.of(context).size,
                  users: common.toList(),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Layout(
          pageText: "Validation",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
                width: double.infinity,
              ),
              if (common.length > 0) ...[
                const Text('some people have other engagements'),
              ] else ...[
                const Text('Meeting Created'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
