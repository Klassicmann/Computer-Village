import 'dart:async';
import 'package:cv/auth/login.dart';
import 'package:cv/screens/instermidiate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cv/screens/introduction.dart';

class FlashPage extends StatefulWidget {
  @override
  _FlashPageState createState() => _FlashPageState();
}

class _FlashPageState extends State<FlashPage> {
  @override
  void initState() {
    flashChecks();
    super.initState();
  }

  int initscreen;
  User _user = FirebaseAuth.instance.currentUser;

  flashChecks() {
    Timer(Duration(seconds: 4), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      initscreen = prefs.getInt("initScreen");
      await prefs.setInt("initScreen", 1);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return initscreen == 0 || initscreen == null
            ? OnBoardingPage()
            : _user != null?  Intermidiate( ) : Login();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        height: double.infinity,
        width: double.infinity,
        child: Image(
          image: AssetImage('assets/images/flash.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
