// import 'dart:developer';

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interview_scheduler/Components/CustomText.dart';
import 'package:interview_scheduler/Components/ListParticipants.dart';
import 'package:interview_scheduler/Components/ShowSnackBar.dart';
import 'package:interview_scheduler/Screens/Layout.dart';
import 'package:interview_scheduler/constants.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:ui';

class ValidateMeeting extends StatefulWidget {
  final DateTime startTimeStamp;
  final DateTime endTimeStamp;
  final Set invalidParts;
  final List selectedParts;
  final String title;
  final String currentMeetingId;
  const ValidateMeeting(
      {Key? key,
      required this.currentMeetingId,
      required this.startTimeStamp,
      required this.endTimeStamp,
      required this.invalidParts,
      required this.selectedParts,
      required this.title})
      : super(key: key);

  @override
  State<ValidateMeeting> createState() => _ValidateMeetingState(startTimeStamp,
      endTimeStamp, invalidParts, selectedParts, title, currentMeetingId);
}

class _ValidateMeetingState extends State<ValidateMeeting> {
  final DateTime startTimeStamp;
  final DateTime endTimeStamp;
  final Set invalidParts;
  final List selectedParts;
  final String currentMeetingId;
  final String title;

  _ValidateMeetingState(this.startTimeStamp, this.endTimeStamp,
      this.invalidParts, this.selectedParts, this.title, this.currentMeetingId);
  @override
  Widget build(BuildContext context) {
    List common = [];
    List mailingList = [];

    void sendMessage() async {
      final Email email = Email(
        body:
            'hello meeting fixed from ${widget.startTimeStamp.toIso8601String()} to ${widget.endTimeStamp.toIso8601String()} ',
        subject: 'A meeting for ${widget.title}',
        recipients:
            widget.selectedParts.map((e) => e['email'].toString()).toList(),
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

    log("selectedParts: " + selectedParts.toString());
    for (int i = 0; i < widget.selectedParts.length; i++) {
      if (widget.invalidParts.contains(widget.selectedParts[i]['id'])) {
        common.add(widget.selectedParts[i]);
      }
    }

    // print(invalidParts);
    // print(selectedParts);
    // print(common);
    // print(selectedParts);
    if (common.isEmpty) {
      try {
        final docMeeting;
        if (currentMeetingId.isEmpty) {
          docMeeting = FirebaseFirestore.instance.collection('Meetings').doc();
        } else {
          docMeeting = FirebaseFirestore.instance
              .collection('Meetings')
              .doc(currentMeetingId);
        }
        var meeting = {
          'id': docMeeting.id,
          'startTime': widget.startTimeStamp,
          'endTime': widget.endTimeStamp,
          'participants': widget.selectedParts,
          'title': widget.title,
        };

        docMeeting.set(meeting);

        // Navigator.pop(context);

        // sendMessage();
        // Navigator.pushNamed(context, '/landing');

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/landing', (Route<dynamic> route) => false);
        });

        if (currentMeetingId.isEmpty)
          showSnackBar(context, 'Meeting Created');
        else
          showSnackBar(context, 'Meeting Updated');

        // Navigator.popUntil(context, (route) => false);

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
                const CustomText(
                    text:
                        "Meeting could not be scheduled due to the following unavailable participants"),
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
