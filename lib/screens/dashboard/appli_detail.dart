import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/constants.dart';
import 'package:cv/models/it_model.dart';
import 'package:cv/screens/dashboard/trainning.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ITAppliDetail extends StatefulWidget {
  final ITAppli appli;
  ITAppliDetail({this.appli});

  @override
  _ITAppliDetailState createState() => _ITAppliDetailState();
}

class _ITAppliDetailState extends State<ITAppliDetail> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    print(widget.appli.useriD);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appli.name),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: ListView(
            children: [
              StudentInfo(
                title: 'Name',
                subtitle: widget.appli.name,
              ),
              StudentInfo(
                title: 'Email',
                subtitle: widget.appli.email,
              ),
              StudentInfo(
                title: 'Gender',
                subtitle: widget.appli.gender,
              ),
              StudentInfo(
                title: 'Phone number',
                subtitle: widget.appli.phone,
              ),
              StudentInfo(
                title: 'Nationality',
                subtitle: widget.appli.nationality,
              ),
              StudentInfo(
                title: 'Town',
                subtitle: widget.appli.town,
              ),
              StudentInfo(
                title: 'Quater',
                subtitle: widget.appli.quater,
              ),
              StudentInfo(
                title: 'Field',
                subtitle: widget.appli.field,
              ),
              StudentInfo(
                title: 'From / Current school',
                subtitle: widget.appli.school,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !widget.appli.status
                      ? MaterialButton(
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                            });
                            await FirebaseFirestore.instance
                                .collection('itapplications')
                                .doc(widget.appli.id)
                                .update({'status': true}).whenComplete(() {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.appli.useriD)
                                  .collection('notifications')
                                  .add({
                                    'title': 'Applictation to join Computer Village accepted',
                                'content':
                                    'Congratulations! Your applcation to join Computer village vocational trainning has been accepted. We will get back to you very shortly',
                                'seen': false,
                                'time': DateTime.now(),
                                'initiator':
                                    FirebaseAuth.instance.currentUser.email,
                                'image': ''
                              }).whenComplete(() => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TrainningDash())));
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
                                    'Are you sure you want to delete this application?',
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
                                          .collection('itapplications')
                                          .doc(widget.appli.id)
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

// FirebaseFirestore.instance
//                                           .collection('users')
//                                           .doc(widget.appli.id)
//                                           .collection('notifications')
//                                           .add({
//                                         'title':
//                                             'Congratulations! Your applcation to join Computer village vocational trainning has been accepted. We will get back to you very shortly',
//                                         'seen': false,
//                                         'time': DateTime.now(),
//                                         'initiator': FirebaseAuth
//                                             .instance.currentUser.email,
//                                         'image': ''
//                                       }).

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
