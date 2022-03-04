import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/constants.dart';
import 'package:cv/models/workmodel.dart';
import 'package:cv/screens/dashboard/trainning.dart';
import 'package:cv/screens/dashboard/work.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class WorkDetail extends StatefulWidget {
  final WorkModel work;
  WorkDetail({this.work});

  @override
  _WorkDetailState createState() => _WorkDetailState();
}

class _WorkDetailState extends State<WorkDetail> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.work.name),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: ListView(
            children: [
              StudentInfo(
                title: 'Name',
                subtitle: widget.work.name,
              ),
           
             
              StudentInfo(
                title: 'Phone number',
                subtitle: widget.work.phone,
              ),
              StudentInfo(
                title: 'Job Description',
                subtitle: widget.work.desc,
              ),
             
             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !widget.work.status
                      ? MaterialButton(
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                            });
                            await FirebaseFirestore.instance
                                .collection('work')
                                .doc(widget.work.id)
                                .update({'status': true}).whenComplete(() {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.work.userId)
                                  .collection('notifications')
                                  .add({
                                'title':
                                    'Your work request with computer village has been accepted',
                                'content':
                                    'We will soon contact you for the next procedures',
                                'seen': false,
                                'time': DateTime.now(),
                                'initiator':
                                    FirebaseAuth.instance.currentUser.email,
                                'image': ''
                              }).whenComplete(() => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Allworks())));
                            }).catchError((error) {
                              print(error);
                            });
                            setState(() {
                              _loading = false;
                            });
                          },
                          color: Colors.green,
                          child: Text(
                            'Confirm',
                            style: klabelStyle.copyWith(color: Colors.white),
                          ),
                        )
                      : Container(),
                  MaterialButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 200,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: ListView(
                                children: [
                                  Text(
                                    'Are you sure you want to delete this work request?',
                                    textAlign: TextAlign.center,
                                    style: kTextTitle,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    color: Colors.blue,
                                    child: Text(
                                      'Cancel',
                                      style: kTextTitle2.copyWith(
                                          color: Colors.white),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('work')
                                          .doc(widget.work.id)
                                          .delete()
                                          .whenComplete(() => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TrainningDash())))
                                          .catchError((error) {
                                        print(error);
                                      });
                                    },
                                    color: Colors.red,
                                    child: Text(
                                      'Delete',
                                      style: kTextTitle2.copyWith(
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    color: Colors.red,
                    child: Text(
                      'Delete',
                      style: klabelStyle.copyWith(color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



class StudentInfo extends StatelessWidget {
  StudentInfo({this.title, this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: kTextTitle2,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              subtitle,
              style: klabelStyle,
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
