import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/screens/dashboard/users.dart';
import 'package:cv/screens/messages.dart';
import 'package:cv/widgets/funtions.dart';
import 'package:cv/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String myemail = FirebaseAuth.instance.currentUser.email;
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ManageUsers()));
        },
        backgroundColor:  Colors.blueGrey,
        child: Icon(Icons.message_outlined),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('messages')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Progress();
            }
            final data = snapshot.data.docs;
            final _user = FirebaseAuth.instance.currentUser.email;
            // Get all messages that concerns the logged in user
            List allmess = [];
            data.forEach((mess) {
              if (mess['sender'] == _user || mess['receiver'] == _user) {
                allmess.add(mess);
              }
            });
            // Remove the ones that were sent by logged in users and received by him
            allmess.removeWhere((element) =>
                element['sender'] == _user && element['receiver'] == _user);

            return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return Progress();
                }

                // Get all the users that sent or receive the messages
                List messUsers = [];

                snapshot.data.docs.forEach((user) {
                  allmess.forEach((elem) {
                    if (user['Email'] == elem['sender'] ||
                        user['Email'] == elem['receiver']) {
                      messUsers.add(user);
                    }
                  });
                });

                messUsers.removeWhere((element) => element['Email'] == _user);

                List cleaned = messUsers.toSet().toList();
                
                List<GestureDetector> fmess = cleaned.map((e) {
                  List hisMessages = [];

                  allmess.forEach((mess) {
                    if ((mess['sender'] == _user &&
                            mess['receiver'] == e['Email']) ||
                        (mess['sender'] == e['Email'] &&
                            mess['receiver'] == _user)) {
                      hisMessages.add(mess);
                    }
                  });

                  List notSeenMessages = [];
                  hisMessages.forEach((element) {
                    if (!element['seen']) {
                      if( element['sender'] != _user){
                      notSeenMessages.add(element);
                      }
                    }
                  });

                  QueryDocumentSnapshot lastMessage;
                  if (hisMessages != [] || hisMessages != null) {
                    lastMessage = hisMessages.first;
                  }
                  String lamess = lastMessage['content'].toString();
                  Timestamp messagetime = lastMessage['time'];

                  final time = DateTime.fromMicrosecondsSinceEpoch(
                      messagetime.microsecondsSinceEpoch);

                  return GestureDetector(
                    onTap: () {
                      notSeenMessages.forEach((element) {
                        FirebaseFirestore.instance
                            .collection('messages')
                            .doc(element.id)
                            .update({'seen': true});
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserMessages(
                                    name: e['Full name'],
                                    email: e['Email'],
                                    photo: e['PhotoUrl'],
                                    myEmail: myemail,
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5)),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: e['PhotoUrl'] != ""
                              ? NetworkImage(e['PhotoUrl'])
                              : AssetImage('assets/images/logo.jpg'),
                        ),
                        title: Text(e['Full name']),
                        subtitle: Text(lamess.length < 30
                            ? lamess
                            : lamess.substring(0, 30) + '...'),
                        trailing: Column(
                          children: [
                            Text(
                              checktime(time),
                              style: GoogleFonts.k2d(
                                  fontSize: 12, color: Colors.black54),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: notSeenMessages.length != 0
                                      ? Colors.red
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                notSeenMessages.length != 0
                                    ? notSeenMessages.length.toString()
                                    : '',
                                style: GoogleFonts.k2d(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList();

                return ListView(
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                    ...fmess
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// class MessageUser {
//   final QueryDocumentSnapshot theuser;
//   final List<QueryDocumentSnapshot> hismessages;

//   MessageUser({this.theuser, this.hismessages});

// }
