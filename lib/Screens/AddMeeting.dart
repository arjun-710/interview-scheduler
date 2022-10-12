import 'dart:developer';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:interview_scheduler/Components/CustomText.dart';
import 'package:interview_scheduler/Components/DateTime.dart';
import 'package:interview_scheduler/Components/SelectPart.dart';
import 'package:interview_scheduler/Screens/Layout.dart';
import 'package:interview_scheduler/constants.dart';

class AddMeeting extends StatefulWidget {
  const AddMeeting({Key? key}) : super(key: key);

  @override
  State<AddMeeting> createState() => _AddMeetingState();
}

class _AddMeetingState extends State<AddMeeting> {
  final DatePickerController _startDateController = DatePickerController();
  DateTime selectedStartDate = DateTime.now();
  final DatePickerController _endDateController = DatePickerController();
  DateTime selectedEndDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Layout(
          pageText: ("Schedule Meeting"),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(text: "Select Time Range"),
              const SizedBox(height: 40),
              DateComponent(
                controller: _startDateController,
                onDateChange: (date) {
                  setState(() {
                    selectedStartDate = date;
                    log(date.toString());
                  });
                },
              ),
              const SizedBox(height: 15),
              DateComponent(
                controller: _endDateController,
                onDateChange: (date) {
                  setState(() {
                    selectedEndDate = date;
                    log(date.toString());
                  });
                },
              ),
              GestureDetector(
                  child: Container(
                    height: 20,
                    child: RichText(
                      text: TextSpan(text: 'add participants'),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (context) => ViewDetails(
                        //   id: meeting.id,
                        // ),
                        builder: (context) => SelectPart(),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
