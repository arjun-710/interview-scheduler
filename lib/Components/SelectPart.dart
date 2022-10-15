import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interview_scheduler/Components/ShowSnackBar.dart';
import 'package:interview_scheduler/Components/UserList.dart';
import 'package:interview_scheduler/Screens/Layout.dart';
import 'package:interview_scheduler/Screens/ValidateMeeting.dart';
import 'package:interview_scheduler/constants.dart';

class SelectPart extends StatefulWidget {
  final DateTime startTimeStamp;
  final DateTime endTimeStamp;
  final String title;
  final String? currentMeetingId;
  final Set already;

  const SelectPart(
      {Key? key,
      required this.already,
      this.currentMeetingId,
      required this.startTimeStamp,
      required this.endTimeStamp,
      required this.title})
      : super(key: key);

  @override
  State<SelectPart> createState() => _SelectPartState(already);
}

class _SelectPartState extends State<SelectPart> {
  final Set already;
  _SelectPartState(this.already);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _partStream =
        FirebaseFirestore.instance.collection('Users').snapshots();

    List allAds = [];
    List<bool> _selected = [];
    Set finalPart = new Set();
    Size size = MediaQuery.of(context).size;

    Future<Map<dynamic, int>> getAll(List new1) async {
      FirebaseFirestore db = FirebaseFirestore.instance;
      Map<dynamic, int> new2 = new Map();
      for (int i = 0; i < new1.length; i++) {
        var query = await db.collection('Meetings').doc(new1[i]).get();

        List data = query.data()!['participants'];
        // log("data: " + data.toString());

        for (int i = 0; i < data.length; i++) {
          // log("participant: " + data[i]['id']);
          // new2.add(data[i]['id']);
          new2.update(
            data[i]['id'],
            (value) => ++value,
            ifAbsent: () => 1,
          );
        }
      }
      return new2;
    }

    void getDataFromMyApi(BuildContext context, DateTime startTimeStamp,
        DateTime endTimeStamp, Set selected) async {
      Map<dynamic, int> parts = Map();

      Set intersecting = new Set();

      FirebaseFirestore db = FirebaseFirestore.instance;

      var data1 = await db
          .collection("Meetings")
          .where("startTime", isGreaterThanOrEqualTo: startTimeStamp)
          .where("startTime", isLessThanOrEqualTo: endTimeStamp)
          .get();

      for (var doc in data1.docs) {
        intersecting.add(doc['id']);
      }

      var data2 = await db
          .collection("Meetings")
          .where("endTime", isGreaterThanOrEqualTo: startTimeStamp)
          .where("endTime", isLessThanOrEqualTo: endTimeStamp)
          .get();

      for (var doc in data2.docs) {
        intersecting.add(doc['id']);
      }

      Set intermediate = Set();

      var data3_1 = await db
          .collection("Meetings")
          .where("startTime", isLessThanOrEqualTo: startTimeStamp)
          .get();

      for (var doc in data3_1.docs) {
        intermediate.add(doc['id']);
      }

      var data3_2 = await db
          .collection("Meetings")
          .where("endTime", isGreaterThanOrEqualTo: endTimeStamp)
          .get();

      for (var doc in data3_2.docs) {
        {
          if (intermediate
              .where((element) => element == doc['id'])
              .isNotEmpty) {
            intersecting.add(doc['id']);
          }
        }
      }
      // log("intersecting meeting: " + intersecting.toString());
      List new1 = intersecting.toList();

      parts = await getAll(new1);

      already.forEach((element) {
        parts.update(element, (value) => --value);
      });

      parts.removeWhere((key, value) => value == 0);

      // log("invalid parts: " + parts.toString());

      log("invalid parts " + parts.toString());

      Set finalInvalidParts = {...parts.keys.toList()};

      Navigator.push(
        context,
        MaterialPageRoute(
          //
          builder: (context) => ValidateMeeting(
              startTimeStamp: startTimeStamp,
              endTimeStamp: endTimeStamp,
              invalidParts: finalInvalidParts,
              selectedParts: selected.toList(),
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
              if (_selected[i])
                finalPart.add(allAds[i]);
              else if (finalPart.contains(allAds[i]))
                finalPart.remove(allAds[i]);
            }
            print(finalPart);
            if (finalPart.length < 2) {
              {
                showSnackBar(context, 'Select atleast 2 participants');
              }
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
                if (snapshot.hasData) {
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
                } else
                  return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
