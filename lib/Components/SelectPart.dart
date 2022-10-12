import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectPart extends StatelessWidget {
  const SelectPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _partStream =
        FirebaseFirestore.instance.collection('Users').snapshots();

    List allAds = [];
    List<bool> _selected = [];
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _partStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      // Fill it with false initiall

                      snapshot.data!.docs.forEach((d) {
                        allAds.add({
                          'name': d['name'],
                          'id': d['id'],
                          'age': d['age']
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
                GestureDetector(
                  child: Container(
                    child: Text('Submit'),
                  ),
                  onTap: () {
                    print("after submission");
                    print(_selected);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListPart extends StatefulWidget {
  const ListPart({Key? key}) : super(key: key);

  @override
  State<ListPart> createState() => _ListPartState();
}

class _ListPartState extends State<ListPart> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return StreamBuilder<QuerySnapshot>(
    //   stream: _partStream,
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text('Something went wrong');
    //     }

    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //     // Fill it with false initially

    //     final allData = snapshot.data!.docs.map((doc) => doc.data()).toList();

    //     List allAds = [];

    //     snapshot.data!.docs.forEach((d) {
    //       allAds.add({'name': d['name'], 'id': d['id'], 'age': d['age']});
    //       // ClassificadoData(d.documentID, d.data["title"],
    //       //     d.data["description"], d.data["price"], d.data["images"])
    //     });
    //     var len = allAds.length;

    //     final List<bool> _selected = List.generate(len, (i) => false);
    //     // print(allData);
    //     // print(allAds);

    //     return UserList(
    //       allData: allData,
    //       len: len,
    //       selected: _selected,
    //     );
    //   },
    // );
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
              tileColor: selected[i]
                  ? Colors.blue
                  : null, // If current item is selected show blue color
              title: Text('${data["name"]}'),
              onTap: () => {
                    setState(() => selected[i] = !selected[i]),
                    print(selected),
                  } // Reverse bool value
              );
        });
  }
}
