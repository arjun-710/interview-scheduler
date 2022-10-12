import 'package:flutter/material.dart';
import 'package:interview_scheduler/constants.dart';

class CustomTextButton extends StatelessWidget {
  final Function()? onTap;
  final String label;

  const CustomTextButton({
    Key? key,
    required this.onTap,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        decoration: BoxDecoration(
            color: kPrimaryColor,
            border: Border.all(width: 2.0, color: Colors.white),
            borderRadius: BorderRadius.circular(25)),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: kTextColor),
        ),
      ),
    );
  }
}
