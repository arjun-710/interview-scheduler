import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interview_scheduler/Components/CustomTextField.dart';
import 'package:interview_scheduler/Components/ShowSnackBar.dart';
import 'package:interview_scheduler/Screens/Layout.dart';
import 'package:interview_scheduler/constants.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
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
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      String name = nameController.text;
                      String email = emailAddressController.text;
                      var age = int.parse(ageController.text);
                      // assert(age is int);

                      try {
                        final docUser = FirebaseFirestore.instance
                            .collection('Users')
                            .doc();
                        final id = docUser.id;
                        var user = {
                          'id': id,
                          'name': name,
                          'email': email,
                          'age': age,
                          'dateAdded': DateTime.now(),
                        };

                        docUser.set(user);
                        showSnackBar(context, "User created");
                      } catch (e) {
                        showSnackBar(context, e.toString());
                      }

                      Navigator.pushNamed(context, '/landing');
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 16),
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        border: Border.all(width: 2.0, color: Colors.white),
                        borderRadius: BorderRadius.circular(25)),
                    child: const Text(
                      'ADD',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kTextColor),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
