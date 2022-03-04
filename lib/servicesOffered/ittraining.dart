import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/constants.dart';
import 'package:cv/screens/full_image.dart';
import 'package:cv/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ITTraining extends StatelessWidget {
  final String userId;
  ITTraining({this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('I.T. Training'),
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
                          image: 'assets/images/cds.jpg',
                        ))),
            child: Container(
                child: Image(image: AssetImage('assets/images/cds.jpg'))),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: RichText(
              text: TextSpan(
                  text:
                      'As shown in the image below, we offer trainning in the following fields\n\n',
                  style: kTextTitle.copyWith(color: Colors.blueGrey),
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
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullImage(
                          url: false,
                          image: 'assets/images/IMG-20210723-WA0003.jpg',
                        ))),
            child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: Image(
                    image:
                        AssetImage('assets/images/IMG-20210723-WA0003.jpg'))),
          ),
          MaterialButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => ItRegistrationForm(
                        userId: userId,
                      ));
            },
            child: Text(
              'Apply Now',
              style: kButtonStyle,
            ),
            color: Theme.of(context).primaryColor,
          )
        ]),
      ),
    );
  }
}

class ItRegistrationForm extends StatefulWidget {
  final String userId;
  ItRegistrationForm({this.userId});
  // const ItRegistrationForm({ Key? key }) : super(key: key);

  @override
  _ItRegistrationFormState createState() => _ItRegistrationFormState();
}

class _ItRegistrationFormState extends State<ItRegistrationForm> {
  final _name = TextEditingController();
  final _town = TextEditingController();
  final _quater = TextEditingController();
  final _phone = TextEditingController();
  final _nationality = TextEditingController();
  final _age = TextEditingController();
  final _gender = TextEditingController();

  final _field = TextEditingController();
  final _fromSchool = TextEditingController();
  final _formkey = GlobalKey<FormState>();

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
                // validator: (val) {
                //   if (val.isEmpty) return 'This field cannot be empty';

                //   return 'Error in this field';
                // },
              ),
              TextFormField(
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                controller: _town,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Town'),
                // validator: (val) {
                //   if (val.isEmpty) return 'This field cannot be empty';

                //   return 'Error in this field';
                // },
              ),
              TextFormField(
                controller: _quater,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Quater'),
                // validator: (val) {
                //   if (val.isEmpty) return 'This field cannot be empty';

                //   return 'Error in this field';
                // },
              ),
              TextFormField(
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Phone'),
                // validator: (val) {
                //   if (val.isEmpty) return 'This field cannot be empty';

                //   return 'Error in this field';
                // },
              ),
              TextFormField(
                controller: _nationality,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                decoration: InputDecoration(
                    labelText: 'Nationality',
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey)),
                // validator: (val) {
                //   if (val.isEmpty) return 'This field cannot be empty';

                //   return 'Error in this field';
                // },
              ),
              TextFormField(
                controller: _age,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Age'),
                // validator: (val) {
                //   if (val.isEmpty) return 'This field cannot be empty';

                //   return 'Error in this field';
                // },
              ),
              TextFormField(
                controller: _gender,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                decoration: InputDecoration(
                    labelText: 'Gender',
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    helperText: 'Male or Female'),
                // validator: (val) {
                //   if (val.isEmpty) return 'This field cannot be empty';

                //   return 'Error in this field';
                // },
              ),
              TextFormField(
                controller: _field,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                keyboardType: TextInputType.multiline,
                // validator: (val) {
                //   if (val.isEmpty) return 'This field cannot be empty';

                //   return 'Error in this field';
                // },
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Field of interest',
                    helperText:
                        'Which field did you choose on the above image'),
              ),
              TextFormField(
                // validator: (val) {
                //   if (val.isEmpty) return 'This field cannot be empty';

                //   return 'Error in this field';
                // },
                controller: _fromSchool,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Which school are you from or currently in?'),
              ),
              MaterialButton(
                onPressed: () async {
                  if (_formkey.currentState.validate()) {
                    setState(() {
                      _loading = true;
                    });
                    String id = widget.userId;
                    await FirebaseFirestore.instance
                        .collection('itapplications')
                        .add({
                      'name': _name.text.trim(),
                      'email': FirebaseAuth.instance.currentUser.email,
                      'town': _town.text.trim(),
                      'quater': _quater.text.trim(),
                      'phone': _phone.text.trim(),
                      'nationality': _nationality.text.trim(),
                      'age': _age.text.trim(),
                      'gender': _gender.text.trim(),
                      'field': _field.text.trim(),
                      'school': _fromSchool.text.trim(),
                      'time': DateTime.now(),
                      'status': false,
                      'seen': false,
                      'userId': id
                    }).whenComplete(() {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(id)
                          .collection('notifications')
                          .add({
                        'title':
                            'Your application to join CV has been recieved',
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
                  }
                },
                child: Text(
                  'Submit',
                  style: kButtonStyle,
                ),
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
