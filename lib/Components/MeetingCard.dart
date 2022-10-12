import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:interview_scheduler/Components/SelectPart.dart';
import 'package:interview_scheduler/Screens/meetingParticipants.dart';
import 'package:interview_scheduler/models/Meeting.dart';

class MeetingCard extends StatefulWidget {
  final Meeting meeting;

  const MeetingCard({Key? key, required this.meeting}) : super(key: key);

  @override
  State<MeetingCard> createState() => _MeetingCardState(meeting);
}

class _MeetingCardState extends State<MeetingCard> {
  final Meeting meeting;

  _MeetingCardState(this.meeting);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // print(meeting);
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.all(10),
          height: 80,
          width: size.width,
          decoration: BoxDecoration(
            color: Color(0xFFEF928F),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(text: TextSpan(text: meeting.title)),
                RichText(
                  text: TextSpan(
                      text: 'From ${meeting.startTime} To ${meeting.endTime}'),
                ),
                RichText(
                  text: TextSpan(text: 'Date - 27/03/2022'),
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
                id: meeting.id,
              ),
              // builder: (context) => SelectPart(),
            ),
          );
        });
  }
}
