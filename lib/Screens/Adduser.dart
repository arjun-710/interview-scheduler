import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:interview_scheduler/Components/CustomTextButton.dart';
import 'package:interview_scheduler/Components/CustomTextField.dart';
import 'package:interview_scheduler/Screens/Layout.dart';
import 'package:interview_scheduler/constants.dart';

class AddUser extends StatelessWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailAddressController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();

    return Scaffold(
      backgroundColor: kPrimaryColor,
      floatingActionButton: FloatingActionButton.extended(
          elevation: 0.0,
          label: const Text('Skip'),
          icon: const Icon(Icons.arrow_forward),
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.pushNamed(context, '/landing');
          }),
      body: Layout(
        pageText: 'Add user',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              controller: nameController,
              hintText: 'Enter Name',
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: emailAddressController,
              hintText: 'Enter email id',
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: ageController,
              hintText: 'Enter Age',
              keyType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextButton(
                onTap: () {
                  String name = nameController.text;
                  String email = emailAddressController.text;
                  var age = int.parse(ageController.text);
                  assert(age is int);

                  final docUser =
                      FirebaseFirestore.instance.collection('Users').doc();
                  final id = docUser.id;
                  var user = {
                    'id': id,
                    'name': name,
                    'email': email,
                    'age': age,
                    'dateAdded': DateTime.now(),
                  };

                  docUser.set(user);

                  Navigator.pushNamed(context, '/landing');
                },
                label: 'ADD')
          ],
        ),
      ),
    );
  }
}
