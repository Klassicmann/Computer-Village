import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/models/user_model.dart';
import 'package:cv/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Intermidiate extends StatefulWidget {
  final int id;

  Intermidiate({this.id});

  @override
  _IntermidiateState createState() => _IntermidiateState();
}

class _IntermidiateState extends State<Intermidiate> {
  List adminEmails = [];
  @override
  void initState() {
    _getAdminEmails();
    super.initState();
  }

  _getAdminEmails() {
    FirebaseFirestore.instance.collection('adminMails').get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          adminEmails.add(element['email']);
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          }
          Cuser cuser;
          snapshot.data.docs.forEach((element) {
            if (element['Email'] == FirebaseAuth.instance.currentUser.email)
              cuser = Cuser(
                  fullName: element['Full name'],
                  email: element['Email'],
                  phone: element['Phone Number'],
                  address: element['Town'],
                  school: element['School'],
                  photoUrl: element['PhotoUrl'],
                  bio: element['Bio'],
                  createdDate: element['Created date'],
                  reference: element.reference,
                  work: element['work'],
                  id: element.id);
          });
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(cuser.id)
                  .collection('notifications')
                  .snapshots(),
              builder: (context, data) {
                if (!data.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blueGrey,
                    ),
                  );
                }
                List notifs = [];
                data.data.docs.forEach((element) {
                  if (!element['seen']) {
                    notifs.add(element);
                  }
                });

                return HomeScreen(
                    id: widget.id, cuser: cuser, notifs: notifs.length, emails : adminEmails);
              });
        });
  }
}
