import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/constants.dart';
import 'package:cv/screens/full_image.dart';
import 'package:cv/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Design extends StatelessWidget {
  final String id;
  Design({this.id});
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphic design'),
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
                            image:
                                'assets/images/d1d1f27dfedd85ccc20e218375492df3.png',
                          ))),
              child: Container(
                  child: Image(
                      image: AssetImage(
                          'assets/images/d1d1f27dfedd85ccc20e218375492df3.png'))),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'We help you with all your graphics. Do you need a logo, a flyer, visit cards, t-shirt designs, banners for your brand? ',
              style: kTextTitle2,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '',
              style: kTextTitle2,
              textAlign: TextAlign.justify,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullImage(
                            url: false,
                            image: 'assets/images/elegant-visit-card-.jpg',
                          ))),
              child: Container(
                  child: Image(
                      image:
                          AssetImage('assets/images/elegant-visit-card-.jpg'))),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Click the button below and post your request and we will get back to you as soon as possible ',
              style: kTextTitle2,
              textAlign: TextAlign.justify,
            ),
            MaterialButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context, builder: (context) => Designheet(id: id,));
              },
              color: Theme.of(context).primaryColor,
              child: Text(
                'Request',
                style: kButtonStyle,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class Designheet extends StatefulWidget {
  final String id;
  Designheet({this.id});

  @override
  _DesignheetState createState() => _DesignheetState();
}

class _DesignheetState extends State<Designheet> {
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
                  if (_phone.text.isNotEmpty &&
                      _name.text.isNotEmpty &&
                      _desc.text.isNotEmpty) {
                    setState(() {
                      loading = true;
                    });
                    await FirebaseFirestore.instance.collection('work').add({
                      'time': DateTime.now(),
                      'name': _name.text.trim(),
                      'phone': _phone.text.trim(),
                      'description': _desc.text.trim(),
                      'userId': widget.id,
                      'status': false,
                      'seen': false,
                    }).whenComplete(() {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.id)
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
