import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/constants.dart';
import 'package:cv/screens/full_image.dart';
import 'package:cv/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Business extends StatelessWidget {
  final String id;
  Business({this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work with us'),
        backgroundColor: Color(0xFF212121),
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
                            image: 'assets/images/laptop-is-my-office.jpg',
                          ))),
              child: Container(
                  child: Image(
                      image:
                          AssetImage('assets/images/laptop-is-my-office.jpg'))),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Do you have a business idea and you don\'t know how to develope it?, do you have money small capital to start something but you don\'t know what to invest on?, well you are in right place. Here, we help people understand which domain is best for them. We give you the opportunity to select amongst our most successfull business ideas and we also work with you to make sure you achive your goals. We have partners in various domains that will help you boost your revenue.',
              style: kTextTitle2,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Want to work with us and make your business grow? click on the button bellow, fill the form and be patient. We will get back to you as soon as possible.',
              style: kTextTitle2,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context, builder: (context) => BusinessSheet(id: id,));
              },
              color: Color(0xFF212121),
              child: Text(
                'Start now',
                style: kButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessSheet extends StatefulWidget {
  final String id;

  BusinessSheet({ this.id}) ;
  // const BusinessSheet({ Key? key }) : super(key: key);

  @override
  _BusinessSheetState createState() => _BusinessSheetState();
}

class _BusinessSheetState extends State<BusinessSheet> {
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
                  helperText: 'Enter a valid phone number'
                ),
               
              ),
              TextFormField(
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                controller: _desc,
                
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                  labelText: 'How can we help you?',
                  helperText: 'Provide a short description about what you want '
                ),
               
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
                color: Color(0xFF212121),
              )
            ],
          ),
        ),
      ),
    );
  }
}
