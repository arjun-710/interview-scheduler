import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interview_scheduler/Components/ListParticipants.dart';
import 'package:interview_scheduler/Screens/Layout.dart';
import 'package:interview_scheduler/constants.dart';
import 'package:intl/intl.dart';

class ViewDetails extends StatelessWidget {
  final String id;
  final String title;
  final String startTime;
  final String endTime;
  final DateTime startDate;
  final DateTime endDate;
  const ViewDetails(
      {Key? key,
      required this.id,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.startDate,
      required this.endDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat _dateFormat = DateFormat('EEEE, MMMM d');
    String formatStartDate = _dateFormat.format(startDate);
    String formatEndDate = _dateFormat.format(startDate);
    return SafeArea(
      child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Layout(
            pageText: title,
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(kCalendarSvg),
                    const SizedBox(width: 27),
                    Column(
                      children: [
                        Text(
                          formatStartDate,
                          style: const TextStyle(
                              fontSize: 16, color: kFadeTextColor),
                        ),
                        // const Text(
                        //   'to',
                        //   style: TextStyle(fontSize: 16, color: kFadeTextColor),
                        // ),
                        Text(
                          formatEndDate,
                          style: const TextStyle(
                              fontSize: 16, color: kFadeTextColor),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '$startTime - $endTime',
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 40),
                GetParticipants(
                  id: id,
                ),
              ],
            ),
          )),
    );
  }
}

class GetParticipants extends StatelessWidget {
  final String id;
  const GetParticipants({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference meetings =
        FirebaseFirestore.instance.collection('Meetings');
    return FutureBuilder<DocumentSnapshot>(
      future: meetings.doc(id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> data =
                snapshot.data?.data() as Map<String, dynamic>;
            List<dynamic> users = [];
            if (data.isNotEmpty) {
              users = ((data['participants'] ?? []) as List);
            }

            return ListParticipants(size: size, users: users);
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}



// class GetParticipants extends StatefulWidget {
//   final String id;
//   const GetParticipants({Key? key, required this.id}) : super(key: key);

//   @override
//   State<GetParticipants> createState() => _GetParticipantsState(id);
// }

// class _GetParticipantsState extends State<GetParticipants> {
//   final String id;
//   _GetParticipantsState(this.id);
//   @override
//   Widget build(BuildContext context) {
//     CollectionReference meetings =
//         FirebaseFirestore.instance.collection('Meetings');
//     return 
//   }
// }