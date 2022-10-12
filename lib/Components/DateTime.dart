import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class DateComponent extends StatelessWidget {
  final DatePickerController controller;
  final void Function(DateTime) onDateChange;

  const DateComponent(
      {Key? key, required this.controller, required this.onDateChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Text(_selectedValue.toString()),
        DatePicker(
          DateTime.now(),
          width: 60,
          height: 80,
          controller: controller,
          initialSelectedDate: DateTime.now(),
          selectionColor: Colors.black,
          selectedTextColor: Colors.white,
          inactiveDates: const [],
          onDateChange: onDateChange,
        ),
      ],
    );
  }
}
