import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/constants.dart';
import 'package:cv/screens/full_image.dart';
import 'package:cv/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AppDevelopement extends StatelessWidget {
  final String userid;
  AppDevelopement({this.userid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Websites and App Developement'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullImage(
                            url: false,
                            image: 'assets/images/study.jpg',
                          ))),
              child: Container(
                  child: Image(image: AssetImage('assets/images/study.jpg'))),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'You have your business and you will like to share it to the rest of the world to meet potential clients, or you just have an idea that you will like to develope and make profit from it through customers online?, you are in the right place. ',
              style: kTextTitle2,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullImage(
                            url: false,
                            image: 'assets/images/unnamed.png',
                          ))),
              child: Container(
                  child: Image(image: AssetImage('assets/images/unnamed.png'))),
            ),
            Text(
              'Computer Village will help you take your business to the next level by briging it online throught and amazing website with a beautiful responsive user friendly design. ',
              style: kTextTitle2,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullImage(
                            url: false,
                            image: 'assets/images/mobile.jpg',
                          ))),
              child: Container(
                  child: Image(image: AssetImage('assets/images/mobile.jpg'))),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'We also build highly personalized proffessional mobile and desktop applications to help you manage and run your business better with high level of security and privacy.\nAfter delivering the project, we continue to provide maintenance and make sure you application or website stays secured. ',
              style: kTextTitle2,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => Bottomsheet(
                          userId: userid,
                        ));
              },
              color: Theme.of(context).primaryColor,
              child: Text(
                'Hire Us',
                style: kButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bottomsheet extends StatefulWidget {
  final String userId;
  Bottomsheet({this.userId});

  @override
  _BottomsheetState createState() => _BottomsheetState();
}

class _BottomsheetState extends State<Bottomsheet> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _desc = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Form(
        key: _formkey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    'Please provide the following information and we will get back to you as soon an possible.',
                    style: klabelStyle,
                  ),
                ),
              ),
              TextFormField(
                controller: _name,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Full name',
                    helperText: 'Please provide your full name '),
              ),
               TextFormField(
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Phone number',
                    helperText: 'Enter a valid phone number'),
              ),
              TextFormField(
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                controller: _desc,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'How can we help you?',
                    helperText:
                        'Provide a short description about what you want '),
              ),
              MaterialButton(
                onPressed: () async {
                  if (_phone.text.isNotEmpty && _name.text.isNotEmpty && _desc.text.isNotEmpty) {
                    setState(() {
                      loading = true;
                    });
                    await FirebaseFirestore.instance.collection('work').add({
                      'time': DateTime.now(),
                      'name': _name.text.trim(),
                      'phone': _phone.text.trim(),
                      'description':_desc.text.trim(),
                      'userId': widget.userId,
                      'status': false,
                      'seen': false,
                    }).whenComplete(() {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userId)
                          .collection('notifications')
                          .add({
                        'title': 'Your request has been recieved',
                        'content':
                            'We will get back to you as soon as possible. ',
                        'seen': false,
                        'time': DateTime.now(),
                        'initiator': FirebaseAuth.instance.currentUser.email,
                        'image': ''
                      }).whenComplete(() {
                        mySnackbar(context);
                        setState(() {
                          loading = false;
                        });
                      });
                    }).catchError((error) {
                      print('error');
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

