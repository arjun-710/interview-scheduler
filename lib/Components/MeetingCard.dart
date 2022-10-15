import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:interview_scheduler/Screens/meetingParticipants.dart';
import 'package:interview_scheduler/constants.dart';
import 'package:interview_scheduler/models/Meeting.dart';
import 'package:intl/intl.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  const MeetingCard({Key? key, required this.meeting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final DateFormat _dateFormat = DateFormat('d-MM-y');
    final DateFormat _timeFormat = DateFormat('HH:mm');
    String startformattedDate = _dateFormat.format(meeting.startTime);
    String endformattedDate = _dateFormat.format(meeting.endTime);
    String startTime = _timeFormat.format(meeting.startTime);
    String endTime = _timeFormat.format(meeting.endTime);

    return GestureDetector(
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 80,
          width: size.width,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    RichText(
                        text: TextSpan(
                            text: meeting.title,
                            style: const TextStyle(fontSize: 22))),
                  ],
                ),
                RichText(
                  text: TextSpan(
                      text: '$startTime - $endTime',
                      style: const TextStyle(fontSize: 16)),
                ),
                RichText(
                  text:
                      TextSpan(text: '$startformattedDate - $endformattedDate'),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewDetails(
                currentMeetingId: meeting.id,
                title: meeting.title,
                startTime: startTime,
                endTime: endTime,
                startDate: meeting.startTime,
                endDate: meeting.endTime,
              ),
            ),
          );
        });
  }
}
