import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/auth/login.dart';
import 'package:cv/auth/register.dart';
import 'package:cv/models/user_model.dart';
import 'package:cv/screens/instermidiate.dart';
import 'package:cv/screens/welcome.dart';
import 'package:cv/widgets/login_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ResetPass extends StatefulWidget {
  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
    _animation = Tween<double>(begin: 50, end: 300).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool loading = false;
  bool obscureText = true;
  bool sent = false;

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
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      color: Colors.blue.withOpacity(0.8),
                      height: _animation.value,
                      width: double.infinity,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.black87,
                      height: _animation.value,
                      width: double.infinity,
                      child: ListView(
                        children: [
                          sent
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Text(
                                        'Password reset link sent successfully. Please check your mail.',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.k2d(
                                            color: Colors.white, fontSize: 19)),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Center(
                                        child: MaterialButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Reset your password',
                                        style: GoogleFonts.k2d(
                                          color: Colors.lightBlue,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )),
                                    LoginField(
                                        controller: _emailController,
                                        label: '  Email',
                                        errorMessage:
                                            'Email feild cannot be empty',
                                        prefixicon: FontAwesomeIcons.at),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 20),
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              loading = true;
                                            });

                                            await FirebaseAuth.instance
                                                .sendPasswordResetEmail(
                                                    email: _emailController.text
                                                        .trim())
                                                .whenComplete(() {
                                              _emailController.clear();
                                              setState(() {
                                                loading = false;
                                                sent = true;
                                              });
                                            }).catchError((error) {
                                              print(error);
                                            });
                                          }
                                        },
                                        child: Text(
                                          'Reset Password',
                                          style: GoogleFonts.k2d(
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                  ],
                                ),
                          Center(
                              child: MaterialButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login())),
                            child: Text(
                              'Back to Login',
                              style: GoogleFonts.k2d(
                                color: Colors.lightBlue,
                                fontSize: 17,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
