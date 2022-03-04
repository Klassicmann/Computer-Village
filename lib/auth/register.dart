import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/auth/confirm_phone.dart';
import 'package:cv/auth/login.dart';
import 'package:cv/auth/update_profile_pic.dart';
import 'package:cv/screens/instermidiate.dart';
import 'package:cv/widgets/dialogs.dart';
import 'package:cv/widgets/login_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
    _animation = Tween<double>(begin: 50, end: 600).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _phoneController = TextEditingController();
  final _townController = TextEditingController();

  bool loading = false;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Image(
                  image: AssetImage('assets/images/flash.png'),
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 600),
                    curve: Curves.linear,
                    color: Colors.blue.withOpacity(0.8),
                    height: _animation.value,
                    width: double.infinity,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 600),
                    curve: Curves.linear,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.black87,
                    height: _animation.value,
                    width: double.infinity,
                    child: ListView(
                      children: [
                        Center(
                            child: MaterialButton(
                          onPressed: () {},
                          child: Text(
                            'Create your Computer Village account',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.k2d(
                              color: Colors.lightBlue,
                              fontSize: 16,
                            ),
                          ),
                        )),
                        LoginField(
                            controller: _nameController,
                            label: 'Full name',
                            errorMessage: 'Name field cannot be empty',
                            prefixicon: FontAwesomeIcons.user),
                        SizedBox(
                          height: 20,
                        ),
                        LoginField(
                            controller: _emailController,
                            label: 'Email address',
                            errorMessage: 'Email field cannot be empty',
                            prefixicon: FontAwesomeIcons.at),
                        SizedBox(
                          height: 20,
                        ),
                        LoginField(
                            controller: _phoneController,
                            label: 'Phone number',
                            errorMessage: 'Phone number field cannot be empty',
                            prefixicon: FontAwesomeIcons.phone),
                        SizedBox(
                          height: 20,
                        ),
                        LoginField(
                            controller: _townController,
                            label: 'Town',
                            errorMessage: 'Town field cannot be empty',
                            prefixicon: FontAwesomeIcons.houseUser),
                        SizedBox(
                          height: 20,
                        ),
                        LoginField(
                          controller: _passController,
                          label: 'Password',
                          errorMessage: 'Password field cannot be empty',
                          prefixicon: FontAwesomeIcons.userLock,
                          pass: obscureText,
                          suffixicon: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.eye,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              }),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                          child: MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });

                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _emailController.text.trim(),
                                        password: _passController.text.trim())
                                    .catchError((e) {
                                  checkErrors(e, context);
                                }).then((value) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .add({
                                    'Full name': _nameController.text.trim(),
                                    'Email': value.user.email,
                                    'School': _schoolController.text.trim(),
                                    'Town': _townController.text.trim(),
                                    'Phone Number':
                                        _phoneController.text.trim(),
                                    'Bio': '',
                                    'PhotoUrl': '',
                                    'Created date': DateTime.now(),
                                    'searchKey': _nameController.text.trim(),
                                    'work':''
                                  }).then((value) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddProfileImage(id: value.id)));
                                  }).whenComplete(() {
                                    setState(() {
                                      loading = false;
                                    });
                                  });
                                }).catchError((error) {
                                  checkErrors(error, context);
                                });
                              }
                            },
                            child: Text(
                              'Register',
                              style: GoogleFonts.k2d(
                                  color: Colors.white, fontSize: 17),
                            ),
                            color: Colors.lightBlue,
                          ),
                        ),
                        Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: GoogleFonts.k2d(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                            MaterialButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login())),
                              child: Text(
                                'Login',
                                style: GoogleFonts.k2d(
                                  color: Colors.lightBlue,
                                  fontSize: 17,
                                ),
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
// Navigator.push(context, (MaterialPageRoute(builder: (context) => AddPhone()))),
