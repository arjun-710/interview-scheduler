import 'dart:developer';
import 'package:interview_scheduler/Components/CustomTextField.dart';
import 'package:interview_scheduler/Components/ShowSnackBar.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:interview_scheduler/Components/CustomText.dart';
import 'package:interview_scheduler/Components/SelectPart.dart';
import 'package:interview_scheduler/Components/CustomTextButton.dart';
import 'package:interview_scheduler/Components/DateTime.dart';
import 'package:interview_scheduler/Screens/Layout.dart';
import 'package:interview_scheduler/constants.dart';

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay addMinutes(int minute) {
    return this.replacing(hour: this.hour, minute: this.minute + minute);
  }
}

class AddMeeting extends StatefulWidget {
  const AddMeeting({Key? key}) : super(key: key);

  @override
  State<AddMeeting> createState() => _AddMeetingState();
}

class _AddMeetingState extends State<AddMeeting> {
  final DatePickerController _startDateController = DatePickerController();
  final TextEditingController controller = TextEditingController();
  DateTime selectedStartDate = DateTime.now();
  final DatePickerController _endDateController = DatePickerController();
  DateTime selectedEndDate = DateTime.now();
  TimeOfDay _startime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().addMinutes(10);

  void _selectstartTime(text) async {
    final TimeOfDay? startTime = await showTimePicker(
        context: context,
        initialTime: _startime,
        initialEntryMode: TimePickerEntryMode.input,
        helpText: text);

    if (startTime != null) {
      setState(() {
        _startime = startTime;
      });
    }
  }

  void _selectendTime(text) async {
    final TimeOfDay? endTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input,
        helpText: text);

    if (endTime != null) {
      setState(() {
        _endTime = endTime;
      });
    }
  }

  final DateFormat _dateFormat = DateFormat('y-MM-d');
  @override
  Widget build(BuildContext context) {
    // print('coming here');
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        floatingActionButton: FloatingActionButton.extended(
            elevation: 0.0,
            label: const Text('Add Participants'),
            icon: const Icon(Icons.add),
            backgroundColor: kPrimaryColor,
            onPressed: () {
              String startformattedDate = _dateFormat.format(selectedStartDate);
              String endformattedDate = _dateFormat.format(selectedEndDate);
              DateTime startTimeStamp = DateTime.parse(
                  '${startformattedDate}T${_startime.hour.toString().padLeft(2, '0')}:${_startime.minute.toString().padLeft(2, '0')}');
              DateTime endTimeStamp = DateTime.parse(
                  '${endformattedDate}T${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}');

              if (startTimeStamp.difference(endTimeStamp).inMinutes > 0) {
                showSnackBar(
                    context, 'start time must be smaller than end time');
              } else if (controller.text.isEmpty) {
                showSnackBar(context, 'Enter a Title');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectPart(
                        startTimeStamp: startTimeStamp,
                        endTimeStamp: endTimeStamp,
                        title: controller.text),
                  ),
                );
              }
              // log(startTimeStamp.toString());
              // log(endTimeStamp.toString());

              // print(DateTime.parse('2020-01-02T07:12')); // 2020-01-02 07:12:00.000
            }),
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
                    // String formattedDate = _dateFormat.format(date);
                    // log(formattedDate);
                    // log(DateTime.parse('2020-01-02T07:12').toString());
                  });
                },
              ),
              const SizedBox(height: 15),
              DateComponent(
                controller: _endDateController,
                onDateChange: (date) {
                  setState(() {
                    selectedEndDate = date;
                    // String formattedDate = _dateFormat.format(date);
                    // log(formattedDate);
                  });
                },
              ),
              const SizedBox(height: 27),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CustomTextButton(
                        label: "Select Start Time",
                        onTap: () {
                          _selectstartTime("Select Start Time");
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomText(text: _startime.format(context))
                    ],
                  ),
                  Column(
                    children: [
                      CustomTextButton(
                        label: "Select End Time",
                        onTap: () {
                          _selectendTime("Select End Time");
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomText(text: _endTime.format(context))
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 27),
              CustomTextField(
                controller: controller,
                hintText: "Enter title",
                // errorText: errorText
              )
            ],
          ),
        ),
      ),
    );
  }
}
