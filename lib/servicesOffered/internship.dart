import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/constants.dart';
import 'package:cv/screens/full_image.dart';
import 'package:cv/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Internship extends StatelessWidget {
  final String userId;
  Internship({this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Internship'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(children: [
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullImage(
                          url: false,
                          image: 'assets/images/IMG-20210723-WA0006.jpg',
                        ))),
            child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                height: MediaQuery.of(context).size.height / 1.8,
                child: Image(
                  image: AssetImage('assets/images/IMG-20210723-WA0006.jpg'),
                  fit: BoxFit.cover,
                )),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                  text: ' We offer internship the following fields\n',
                  style: kTextTitle,
                  children: [
                    TextSpan(
                        text: 'Web and Mobile Developement \n',
                        style: kTextTitle2),
                    TextSpan(
                        text: 'Computer Maintenance\n', style: kTextTitle2),
                    TextSpan(text: 'Digital Marketing\n', style: kTextTitle2),
                    TextSpan(text: 'Graphic Design\n', style: kTextTitle2),
                    TextSpan(
                        text: 'Database Administration\n', style: kTextTitle2),
                    TextSpan(
                        text: 'Network Adminstration\n', style: kTextTitle2),
                    TextSpan(
                        text: 'General Computing Knwoledge\n',
                        style: kTextTitle2),
                    TextSpan(text: 'Secretarial Studies\n', style: kTextTitle2),
                    TextSpan(
                        text: 'Computarized Accounting\n', style: kTextTitle2),
                  ]),
            ),
          ),
          Text(
              'At the end of the intership, we continue to assist students in their report and project, to make sure they have a good defence and good results at the end of the year.'),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context, builder: (context) => InternshipForm(id: userId,));
            },
            child: Text(
              'Apply Now',
              style: kButtonStyle,
            ),
            color: Colors.blue,
          )
        ]),
      ),
    );
  }
}

class InternshipForm extends StatefulWidget {
  final String id;
  InternshipForm({this.id});

  @override
  _InternshipFormState createState() => _InternshipFormState();
}

class _InternshipFormState extends State<InternshipForm> {
  final _name = TextEditingController();
  final _town = TextEditingController();

  final _field = TextEditingController();
  final _fromSchool = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _phone = TextEditingController();


  // List _file = [];

  // String _fileName;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          height: 500,
          padding: EdgeInsets.symmetric(horizontal: 15),
          color: Colors.grey[200],
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                decoration: InputDecoration(
                  labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                  labelText: 'Full name',
                ),
              ),
              TextFormField(
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                controller: _town,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Town'),
              ),
            
              TextFormField(
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Phone'),
              ),
              TextFormField(
                controller: _field,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Field ',
                    helperText: 'In which field are you?'),
              ),
              TextFormField(
                controller: _fromSchool,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Your current school?'),
              ),
              // GestureDetector(
              //   onTap: () async {
              //     FilePickerResult filePicker =
              //         await FilePicker.platform.pickFiles(allowMultiple: false);
              //     if (filePicker != null) {
              //       setState(() {
              //         _file.add(filePicker.paths);
              //          _fileName = filePicker.names.first;
              //           print(_fileName);
              //       });
              //     }
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              //     color: Colors.grey,
              //     child: Text(
              //       _fileName != null
              //           ? _fileName
              //           : 'Upload your application form',
              //       style: GoogleFonts.k2d(fontSize: 18, color: Colors.white),
              //     ),
              //   ),
              // ),
              MaterialButton(
                onPressed: () {
                  if (_phone.text.isNotEmpty &&
                      _field.text.isNotEmpty &&
                      _fromSchool.text.isNotEmpty &&
                      _name.text.isNotEmpty &&
                      _town.text.isNotEmpty) {
                    setState(() {
                      _loading = true;
                    });
                    FirebaseFirestore.instance.collection('internship').add({
                      'name': _name.text.trim(),
                      'town': _town.text.trim(),
                      'phone': _phone.text.trim(),
                      'field': _field.text.trim(),
                      'school': _fromSchool.text.trim(),
                      'email':FirebaseAuth.instance.currentUser.email,
                      'userId': widget.id,
                      'time': DateTime.now(),
                      'status': false,
                      'seen': false,
                    }).whenComplete(() {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.id)
                          .collection('notifications')
                          .add({
                        'title':
                            'Your application to join CV iternship program has been recieved',
                        'content':
                            'We will review it and get back to you as soon as possible. ',
                        'seen': false,
                        'time': DateTime.now(),
                        'initiator': FirebaseAuth.instance.currentUser.email,
                        'image': ''
                      }).whenComplete(() {
                        mySnackbar(context);
                        setState(() {
                          _loading = false;
                        });
                      });
                    }).catchError((error) {
                      print(error);
                    });
                  } else {
                    emptyDialog(context);
                  }
                },
                child: Text(
                  'Submit',
                  style: kButtonStyle,
                ),
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
