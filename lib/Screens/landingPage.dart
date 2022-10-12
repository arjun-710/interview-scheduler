import 'package:flutter/material.dart';
import 'package:interview_scheduler/Components/CustomText.dart';
import 'package:interview_scheduler/Screens/Layout.dart';
import 'package:interview_scheduler/constants.dart';
import 'package:interview_scheduler/models/Meeting.dart';
import 'package:interview_scheduler/services/meetingServices.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        floatingActionButton: FloatingActionButton.extended(
            elevation: 0.0,
            label: const Text('Add meeting'),
            icon: const Icon(Icons.add),
            backgroundColor: kPrimaryColor,
            onPressed: () {
              Navigator.pushNamed(context, '/addMeeting');
            }),
        body: Layout(
          pageText: "Home",
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(text: "Your Meetings"),
              const SizedBox(height: 40),
              StreamBuilder<List<Meeting>>(
                stream: readMeetings(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something Went Wrong");
                  } else if (snapshot.hasData) {
                    final meetings = snapshot.data!;
                    return Container(
                      height: size.height - size.height * 0.4,
                      child: ListView(
                        children: meetings.map(buildMeeting).toList(),
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              // Positioned(child: )
            ],
          ),
        ),
      ),
    );
  }
}
