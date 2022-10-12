import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ValidateMeeting extends StatefulWidget {
  final DateTime startTimeStamp;
  final DateTime endTimeStamp;
  final List invalidParts;
  final List selectedParts;
  const ValidateMeeting(
      {Key? key,
      required this.startTimeStamp,
      required this.endTimeStamp,
      required this.invalidParts,
      required this.selectedParts})
      : super(key: key);

  @override
  State<ValidateMeeting> createState() => _ValidateMeetingState(
      startTimeStamp, endTimeStamp, invalidParts, selectedParts);
}

class _ValidateMeetingState extends State<ValidateMeeting> {
  final DateTime startTimeStamp;
  final DateTime endTimeStamp;
  final List invalidParts;
  final List selectedParts;
  _ValidateMeetingState(this.startTimeStamp, this.endTimeStamp,
      this.invalidParts, this.selectedParts);

  @override
  Widget build(BuildContext context) {
    // print(startTimeStamp);
    // print(endTimeStamp);
    // print(finalPart);

    // print(invalidPart);
    // print(data);
    print(selectedParts);
    return Scaffold(
      body: Container(),
    );
  }
}
