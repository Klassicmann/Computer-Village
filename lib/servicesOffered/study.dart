import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/constants.dart';
import 'package:cv/screens/full_image.dart';
import 'package:cv/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Study extends StatelessWidget {
  final String userId;
  Study({this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study in India'),
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
                            image: 'assets/images/ivankatrump_story.jpg',
                          ))),
              child: Container(
                  child: Image(
                      image:
                          AssetImage('assets/images/ivankatrump_story.jpg'))),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '  India is vast in every sense of the word. From its population of more than one billion, to its expansive cities, to its wide-open, seemingly-endless countryside, India certainly earns its subcontinent status. India is home to dozens of communities, languages and several religions. It is also home to some of the most beautiful buildings in the world, like the Taj Mahal and the Golden Temple. ',
              style: kTextTitle2,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              ' As a study abroad destination in Asia, India ranks high on experiencing a new culture or lifestyle. One thing for which India is best known across the world is also one of the major draws for international students: the food. As the world has become more and more interconnected, curries, naans, poppadums and sugar puddings have spread around the world – and have come to be adored by billions of people. There is also India’s national dress. Its vivid colors and patterns capture our imaginations. Of course, India also has rich, fascinating stories, from the origin stories of the Hindu gods through to traditional folktales and legends, Indian stories have more than enough to keep you enthralled for hours at a time. ',
              style: kTextTitle2,
              textAlign: TextAlign.justify,
            ),
            MaterialButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => StudyForm(
                          id: userId,
                        ));
              },
              color: Theme.of(context).primaryColor,
              child: Text(
                'Know More',
                style: kButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudyForm extends StatefulWidget {
  final String id;
  StudyForm({this.id});

  @override
  _StudyFormState createState() => _StudyFormState();
}

class _StudyFormState extends State<StudyForm> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _desc= TextEditingController();

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
                    await FirebaseFirestore.instance.collection('study').add({
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
