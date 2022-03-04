import 'package:cv/auth/register.dart';
import 'package:cv/auth/reset_password.dart';
import 'package:cv/screens/instermidiate.dart';
import 'package:cv/widgets/dialogs.dart';
import 'package:cv/widgets/login_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
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
    _animation = Tween<double>(begin: 50, end: 420).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.black87,
                      height: _animation.value,
                      width: double.infinity,
                      child: ListView(
                        children: [
                          Center(
                              child: MaterialButton(
                            onPressed: () {},
                            child: Text(
                              'Login with email and password',
                              style: GoogleFonts.k2d(
                                color: Colors.lightBlue,
                                fontSize: 16,
                              ),
                            ),
                          )),
                          LoginField(
                              controller: _emailController,
                              label: '  Email',
                              errorMessage: 'Email feild cannot be empty',
                              prefixicon: FontAwesomeIcons.at),
                          SizedBox(
                            height: 20,
                          ),
                          LoginField(
                            controller: _passController,
                            label: '  Password',
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            child: MaterialButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });

                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _emailController.text.trim(),
                                            password:
                                                _passController.text.trim())
                                        .then((value) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Intermidiate()));
                                    });
                                  } catch (e) {
                                    checkErrors(e, context);
                                  }

                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                              child: Text(
                                'Login',
                                style: GoogleFonts.k2d(
                                    color: Colors.white, fontSize: 17),
                              ),
                              color: Colors.lightBlue,
                            ),
                          ),
                          Center(
                              child: MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPass())),
                            child: Text(
                              'I forgot my password',
                              style: GoogleFonts.k2d(
                                color: Colors.lightBlue,
                                fontSize: 17,
                              ),
                            ),
                          )),
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: GoogleFonts.k2d(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register())),
                                child: Text(
                                  'Register',
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
                ),
              ],
            ),
          ),
        ));
  }
}
