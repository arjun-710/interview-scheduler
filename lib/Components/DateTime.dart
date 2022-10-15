import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class DateComponent extends StatelessWidget {
  final DatePickerController controller;
  final void Function(DateTime) onDateChange;
  final DateTime? timestamp;
  const DateComponent({
    Key? key,
    this.timestamp,
    required this.controller,
    required this.onDateChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Text(_selectedValue.toString()),
        DatePicker(
          timestamp ?? DateTime.now(),
          width: 60,
          height: 80,
          controller: controller,
          initialSelectedDate: timestamp ?? DateTime.now(),
          selectionColor: Colors.black,
          selectedTextColor: Colors.white,
          inactiveDates: const [],
          onDateChange: onDateChange,
        ),
      ],
    );
  }
}
