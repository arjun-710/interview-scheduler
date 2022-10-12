import 'package:flutter/material.dart';
import 'package:interview_scheduler/constants.dart';

class CustomText extends StatelessWidget {
  final String text;
  const CustomText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
            color: kHeadingColor, fontSize: 25, fontFamily: 'segoe-UI'),
      ),
    );
  }
}
