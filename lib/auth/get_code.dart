
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class GetCode extends StatefulWidget {
  @override
  _GetCodeState createState() => _GetCodeState();
}

class _GetCodeState extends State<GetCode> with TickerProviderStateMixin {
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
  String phonecode;

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
                            'Enter the confirmation code that has been sent to you through sms',

                            // textAlign: TextAlign.center,
                            style: GoogleFonts.k2d(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        )),
                        counterController.value.toInt() != 0
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Text(
                                      'Resend confirm code in ',
                                      style: GoogleFonts.k2d(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                    Text(
                                      '${counterController.value.toInt()}',
                                      style: GoogleFonts.k2d(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'Resend confirm code ',
                                    style: GoogleFonts.k2d(
                                        color: Colors.blue, fontSize: 17),
                                  ),
                                ),
                              ),
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.k2d(
                                color: Colors.orange,
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(bottom: 10),
                                  hintText: '00000'),
                              onChanged: (value) {
                                setState(() {
                                  phonecode = value;
                                });
                              },
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: MaterialButton(
                            onPressed: () => Navigator.pop(context, phonecode),
                            child: Text(
                              'Confirm code',
                              style: GoogleFonts.k2d(
                                  color: Colors.white, fontSize: 17),
                            ),
                            color: Colors.lightBlue,
                          ),
                        ),
                      ])),
                ),
              ],
            ),
          ),
        ));
  }
}
