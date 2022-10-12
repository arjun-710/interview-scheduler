import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewDetails extends StatelessWidget {
  final String id;
  const ViewDetails({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Interview Participants",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                    height: MediaQuery.of(context).size.height / 1.75,
                    child: GetParticipants(
                      id: id,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GetParticipants extends StatefulWidget {
  final String id;
  const GetParticipants({Key? key, required this.id}) : super(key: key);

  @override
  State<GetParticipants> createState() => _GetParticipantsState(id);
}

class _GetParticipantsState extends State<GetParticipants> {
  final String id;
  _GetParticipantsState(this.id);
  @override
  Widget build(BuildContext context) {
    CollectionReference meetings =
        FirebaseFirestore.instance.collection('Meetings');
    return FutureBuilder<DocumentSnapshot>(
      future: meetings.doc(id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              child: Text("Something went wrong"),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> data =
                snapshot.data?.data() as Map<String, dynamic>;
            List<dynamic> users = [];
            if (data.isNotEmpty) {
              users = ((data['participants'] ?? []) as List);
            }

            // print(users[1]['name']);

            return Expanded(
              child: SizedBox(
                height: 200.0,
                child: ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    var data = users[index];
                    return Container(
                      decoration: BoxDecoration(
                        // color: kCream,
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFEF928F),
                      ),

                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                                text: TextSpan(
                                    text: data['name'],
                                    style: TextStyle(color: Colors.black))),
                            SizedBox(
                              height: 20,
                            ),
                            RichText(
                              text: TextSpan(
                                  text: data['id'],
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                      // child: ListTile(
                      //   onTap: () {
                      //     // Navigator.push(
                      //     //   context,
                      //     //   MaterialPageRoute(
                      //     //     builder: (context) => ViewRecords(
                      //     //       id: data["patId"],
                      //     //     ),
                      //     //   ),
                      //     // );
                      //   },
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(25),
                      //   ),
                      //   leading: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         padding: EdgeInsets.all(12),
                      //         decoration: BoxDecoration(
                      //             color: Colors.white,
                      //             borderRadius: BorderRadius.circular(25)),
                      //         // child: SvgPicture.asset(kCheckUp)
                      //       )
                      //     ],
                      //   ),
                      //   minLeadingWidth: 20,
                      //   title: Padding(
                      //     padding: EdgeInsets.only(left: 5, bottom: 5),
                      //     child: Text(data["name"]),
                      //   ),
                      //   subtitle: Row(
                      //     children: [
                      //       Text(data["id"]),
                      //     ],
                      //   ),
                      //   // trailing: SvgPicture.asset(kRight),
                      // ),
                    );
                  },
                ),
              ),
            );
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
