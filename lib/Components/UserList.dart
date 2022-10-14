import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  final List selected;
  final List allParts;
  final int len;
  const UserList(
      {Key? key,
      required this.allParts,
      required this.len,
      required this.selected})
      : super(key: key);

  @override
  State<UserList> createState() => _UserListState(allParts, len, selected);
}

class _UserListState extends State<UserList> {
  final List allParts;
  final int len;
  final List selected;
  _UserListState(this.allParts, this.len, this.selected);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: len,
        scrollDirection: Axis.vertical,
        itemBuilder: (_, i) {
          var data = allParts[i];

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
