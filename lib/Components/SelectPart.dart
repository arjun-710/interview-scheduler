import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interview_scheduler/Components/ShowSnackBar.dart';
import 'package:interview_scheduler/Screens/Layout.dart';
import 'package:interview_scheduler/Screens/ValidateMeeting.dart';
import 'package:interview_scheduler/constants.dart';

class SelectPart extends StatefulWidget {
  final DateTime startTimeStamp;
  final DateTime endTimeStamp;
  final String title;
  const SelectPart(
      {Key? key,
      required this.startTimeStamp,
      required this.endTimeStamp,
      required this.title})
      : super(key: key);

  @override
  State<SelectPart> createState() => _SelectPartState();
}

class _SelectPartState extends State<SelectPart> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _partStream =
        FirebaseFirestore.instance.collection('Users').snapshots();

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(kMarginTopBottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              kleftSvg,
                            ),
                          ),
                          const SizedBox(height: 13),
                          const Text(
                            'Add Participants',
                            style: TextStyle(
                                color: kTextColor,
                                fontSize: 25,
                                fontFamily: 'segoe-UI'),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.175),
                      padding: EdgeInsets.only(bottom: 30),
                      decoration: const BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _partStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            // Fill it with false initiall

                            snapshot.data!.docs.forEach((d) {
                              allAds.add({
                                'name': d['name'],
                                'id': d['id'],
                                'age': d['age'],
                                'email': d['email'],
                              });
                              _selected.add(false);
                              // ClassificadoData(d.documentID, d.data["title"],
                              //     d.data["description"], d.data["price"], d.data["images"])
                            });
                            var len = allAds.length;

                            // print(allData);
                            // print(allAds);

                            return UserList(
                              allData: allAds,
                              len: len,
                              selected: _selected,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserList extends StatefulWidget {
  final List selected;
  final List allData;
  final int len;
  const UserList(
      {Key? key,
      required this.allData,
      required this.len,
      required this.selected})
      : super(key: key);

  @override
  State<UserList> createState() => _UserListState(allData, len, selected);
}

class _UserListState extends State<UserList> {
  final List allData;
  final int len;
  final List selected;
  _UserListState(this.allData, this.len, this.selected);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: len,
        itemBuilder: (_, i) {
          var data = allData[i];

          return ListTile(

              // selectedTileColor: Colors.blue,
              // tileColor: selected[i]
              //     ? Colors.blue
              //     : null, // If current item is selected show blue color
              title: Text('${data["name"]} \n${data["email"]}'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (selected[i] == true) ...[
                    RichText(
                      text: const TextSpan(
                          text: 'Selected',
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ] else ...[
                    const Text(''),
                  ],
                  const Divider(),
                ],
              ),
              onTap: () => {
                    setState(() => selected[i] = !selected[i]),
                    // print(selected),
                  } // Reverse bool value
              );
        });
  }
}
