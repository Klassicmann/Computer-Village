import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/auth/get_code.dart';
import 'package:cv/auth/update_profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AddPhone extends StatefulWidget {
  final String id;

  AddPhone({this.id});

  @override
  _AddPhoneState createState() => _AddPhoneState();
}

class _AddPhoneState extends State<AddPhone> with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;
  AnimationController counterController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
    _animation = Tween<double>(begin: 50, end: 300).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));

    counterController = AnimationController(
        duration: Duration(seconds: 60), upperBound: 60, vsync: this);

    counterController.reverse(from: 60);
    counterController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    counterController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool code = false;
  bool loading = false;

  String pnumber;

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
                        child: ListView(children: [
                          Center(
                              child: MaterialButton(
                            onPressed: () {},
                            child: Text(
                              'Add your phone number',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.k2d(
                                color: Colors.lightBlue,
                                fontSize: 16,
                              ),
                            ),
                          )),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.only(left: 5),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  setState(() {
                                    pnumber = number.phoneNumber;
                                  });
                                },
                                textStyle: GoogleFonts.aBeeZee(fontSize: 18),
                                selectorConfig: SelectorConfig(
                                  selectorType:
                                      PhoneInputSelectorType.BOTTOM_SHEET,
                                ),
                                ignoreBlank: false,
                                selectorTextStyle:
                                    TextStyle(color: Colors.black),
                                // initialValue: phoneN,
                                formatInput: false,

                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                inputBorder: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 5),
                            child: MaterialButton(
                              onPressed: () async {

                                FirebaseAuth _auth = FirebaseAuth.instance;
                                await _auth.verifyPhoneNumber(
                                    phoneNumber: pnumber,
                                    timeout: Duration(seconds: 60),
                                    verificationCompleted:
                                        (AuthCredential authCredi) async {
                                          setState(() {
                                        loading = true;
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.id)
                                          .update(
                                        {'Phone Number': pnumber},
                                      ).then((value) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddProfileImage(
                                                      id: widget.id,
                                                    ))).whenComplete(() {
                                          setState(() {
                                            loading = false;
                                          });
                                        });
                                      }).catchError((error) {
                                        print(error);
                                      });
                                    },
                                    verificationFailed:
                                        (FirebaseAuthException authException) {
                                      print(authException);
                                    },
                                    codeSent: (String veriId,
                                        [int forceResendingToken]) async {
                                      String code;
                                      code = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => GetCode()));
                                      
                                      PhoneAuthCredential _credential =
                                          PhoneAuthProvider.credential(
                                              verificationId: veriId,
                                              smsCode: code);
                                      setState(() {
                                        loading = true;
                                      });
                                      await _auth
                                          .signInWithCredential(_credential)
                                          .then((value) {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(widget.id)
                                            .update(
                                          {'Phone Number': pnumber},
                                        ).then((value) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddProfileImage(
                                                        id: widget.id,
                                                      ))).whenComplete(() {
                                            setState(() {
                                              loading = false;
                                            });
                                          });
                                        }).catchError((error) {
                                          print(error);
                                        });
                                      });
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationId) {
                                      verificationId = verificationId;
                                      print(verificationId);
                                      print("Timout");
                                    });
                              },
                              child: Text(
                                'Add phone',
                                style: GoogleFonts.k2d(
                                    color: Colors.white, fontSize: 17),
                              ),
                              color: Colors.lightBlue,
                            ),
                          ),
                        ]))),
              ],
            ),
          ),
        ));
  }
}
