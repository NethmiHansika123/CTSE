import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/common/theme_helper.dart';

class UpdateStudentPage extends StatefulWidget {
  final String id;
  UpdateStudentPage({Key? key, required this.id}) : super(key: key);

  @override
  _UpdateStudentPageState createState() => _UpdateStudentPageState();
}

class _UpdateStudentPageState extends State<UpdateStudentPage> {
  final _formKey = GlobalKey<FormState>();

  // Updaing Student
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  Future<void> updateUser(id, fname, lname, email, mobile) {
    return students
        .doc(id)
        .update(
            {'fname': fname, 'lname': lname, 'email': email, 'mobile': mobile})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Student"),
      ),
      body: Form(
          key: _formKey,
          // Getting Specific Data by ID
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('students')
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print('Something Went Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              }
              var data = snapshot.data!.data();
              var fname = data!['fname'];
              var lname = data['lname'];
              var email = data['email'];
              var mobile = data['mobile'];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                          initialValue: fname,
                          autofocus: false,
                          onChanged: (value) => fname = value,
                          decoration: ThemeHelper().textInputDecoration(
                              'First Name', 'Enter your first name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter First Name';
                            }
                            return null;
                          }),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                          initialValue: lname,
                          autofocus: false,
                          onChanged: (value) => lname = value,
                          decoration: ThemeHelper().textInputDecoration(
                              'Last Name', 'Enter your Last name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Last Name';
                            }
                            return null;
                          }),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: email,
                        autofocus: false,
                        onChanged: (value) => email = value,
                        decoration: ThemeHelper().textInputDecoration(
                            "E-mail address", "Enter your email"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (!(val!.isEmpty) &&
                              !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(val)) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                          initialValue: mobile,
                          autofocus: false,
                          onChanged: (value) => mobile = value,
                          decoration: ThemeHelper().textInputDecoration(
                              'Mobile No.', 'Enter your Mobile number'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Mobile number';
                            }
                            return null;
                          }),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState!.validate()) {
                                updateUser(
                                    widget.id, fname, lname, email, mobile);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Update',
                              style: const TextStyle(fontSize: 24.0),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
