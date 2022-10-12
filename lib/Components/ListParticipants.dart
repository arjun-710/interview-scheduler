import 'package:flutter/material.dart';
import 'package:interview_scheduler/constants.dart';

class ListParticipants extends StatelessWidget {
  const ListParticipants({
    Key? key,
    required this.size,
    required this.users,
  }) : super(key: key);

  final Size size;
  final List users;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height / 2,
          child: ListView.separated(
            itemCount: users.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              var data = users[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kPrimaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: data['name'],
                            style: const TextStyle(color: kTextColor)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
