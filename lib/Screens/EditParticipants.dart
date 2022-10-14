import 'dart:developer';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interview_scheduler/Components/ShowSnackBar.dart';
import 'package:interview_scheduler/Components/UserList.dart';
import 'package:interview_scheduler/Screens/Layout.dart';
import 'package:interview_scheduler/Screens/ValidateMeeting.dart';
import 'package:interview_scheduler/constants.dart';

class EditPart extends StatefulWidget {
  final DateTime startTimeStamp;
  final DateTime endTimeStamp;
  final String title;
  final String id;
  final Set already;
  const EditPart(
      {Key? key,
      required this.startTimeStamp,
      required this.endTimeStamp,
      required this.title,
      required this.id,
      required this.already})
      : super(key: key);

  @override
  State<EditPart> createState() => _EditPartState(id, already);
}

class _EditPartState extends State<EditPart> {
  final String id;
  final Set already;
  _EditPartState(this.id, this.already);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _partStream =
        FirebaseFirestore.instance.collection('Users').snapshots();

    // log(already.toString());

    List allAds = [];
    List<bool> _selected = [];
    List finalPart = [];
    Size size = MediaQuery.of(context).size;

    void getDataFromMyApi(BuildContext context, DateTime startTimeStamp,
        DateTime endTimeStamp, List selected) async {
      FirebaseFirestore db = FirebaseFirestore.instance;

      Set<dynamic> parts = Set();

      var data1 = await db
          .collection("Meetings")
          .where("startTime", isGreaterThanOrEqualTo: startTimeStamp)
          .where("startTime", isLessThanOrEqualTo: endTimeStamp)
          .get();

      for (var doc in data1.docs) {
        for (var participant in doc['participants']) parts.add(participant);
      }

      var data2 = await db
          .collection("Meetings")
          .where("endTime", isGreaterThanOrEqualTo: startTimeStamp)
          .where("endTime", isLessThanOrEqualTo: endTimeStamp)
          .get();

      for (var doc in data2.docs) {
        for (var participant in doc['participants']) parts.add(participant);
      }

      Set intermediate = Set();

      var data3_1 = await db
          .collection("Meetings")
          .where("startTime", isLessThanOrEqualTo: startTimeStamp)
          .get();

      for (var doc in data3_1.docs) {
        for (var participant in doc['participants'])
          intermediate.add(participant);
      }

      var data3_2 = await db
          .collection("Meetings")
          .where("endTime", isGreaterThanOrEqualTo: endTimeStamp)
          .get();

      for (var doc in data3_2.docs) {
        for (var participant in doc['participants']) {
          if (intermediate
              .where((element) => element['id'] == participant['id'])
              .isNotEmpty) {
            parts.add(participant);
          }
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          //
          builder: (context) => ValidateMeeting(
              startTimeStamp: startTimeStamp,
              endTimeStamp: endTimeStamp,
              invalidParts: parts,
              selectedParts: selected,
              title: widget.title),
        ),
      ).then((value) => {
            setState(() {
              finalPart.clear();
              parts.clear();
            }),
          });
    }

    return Scaffold(
      backgroundColor: kPrimaryColor,
      floatingActionButton: FloatingActionButton.extended(
          elevation: 0.0,
          label: const Text('Create meeting'),
          icon: const Icon(Icons.add),
          backgroundColor: kPrimaryColor,
          onPressed: () {
            // print(startTimeStamp.toIso8601String());
            // print(endTimeStamp.toIso8601String());

            for (int i = 0; i < _selected.length; i++) {
              if (_selected[i]) finalPart.add(allAds[i]);
            }
            print(finalPart);
            if (finalPart.length < 2) {
              showSnackBar(context, 'Select atleast 2 participants');
            } else
              getDataFromMyApi(context, widget.startTimeStamp,
                  widget.endTimeStamp, finalPart);

            // allAds.clear();
            // print(finalPart);
            // Navigator.pushNamed(context, '/addMeeting');
          }),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Layout(
          pageText: 'Add Participants',
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _partStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Fill it with false initiall

                snapshot.data!.docs.forEach((d) {
                  allAds.add({
                    'name': d['name'],
                    'id': d['id'],
                    'age': d['age'],
                    'email': d['email'],
                  });

                  if (already.contains(d['id']))
                    _selected.add(true);
                  else
                    _selected.add(false);
                  // ClassificadoData(d.documentID, d.data["title"],
                  //     d.data["description"], d.data["price"], d.data["images"])
                });
                var len = allAds.length;

                // print(allData);
                // print(allAds);

                return UserList(
                  allParts: allAds,
                  len: len,
                  selected: _selected,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
