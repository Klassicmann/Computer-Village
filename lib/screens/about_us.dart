import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/models/user_model.dart';
import 'package:cv/screens/dashboard/create_post.dart';
import 'package:cv/screens/forum.dart';
import 'package:cv/screens/messages.dart';
import 'package:cv/screens/my_messages.dart';
import 'package:cv/screens/who.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatelessWidget {
  final Cuser cuser;
  AboutUs({this.cuser});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            SizedBox(
              height: 100,
            ),
            //   GestureDetector(
            //   onTap: () => Navigator.push(
            //       context, MaterialPageRoute(builder: (context) => MyMessages())),
            //   child: AnimatedContainer(
            //     duration: Duration(seconds: 2),
            //     curve: Curves.linear,
            //     // width: MediaQuery.of(context).size.width / 2,
            //     margin: EdgeInsets.only(right: 150, bottom: 20),
            //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //     child: Text(
            //       'Messages',
            //       style: GoogleFonts.k2d(
            //           fontSize: 23,
            //           color: Colors.white,
            //           fontWeight: FontWeight.w600),
            //     ),
            //     decoration: BoxDecoration(
            //         color: Colors.lightBlue,
            //         borderRadius: BorderRadius.only(
            //           topRight: Radius.circular(30),
            //           bottomRight: Radius.circular(30),
            //         )),
            //   ),
            // ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreatPost(
                            reference: cuser.reference,
                          ))),
              child: AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.linear,
                // width: MediaQuery.of(context).size.width / 2,
                margin: EdgeInsets.only(right: 120, bottom: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Create a post',
                  style: GoogleFonts.k2d(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Forum(cuser: cuser))),
              child: AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.linear,
                // width: MediaQuery.of(context).size.width / 2,
                margin: EdgeInsets.only(right: 200, bottom: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Forum',
                  style: GoogleFonts.k2d(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Who())),
              child: AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.easeIn,
                margin: EdgeInsets.only(right: 100, bottom: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Wo we are',
                  style: GoogleFonts.k2d(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.easeIn,
                margin: EdgeInsets.only(right: 200, bottom: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'FAQs',
                  style: GoogleFonts.k2d(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )),
              ),
            ),
            GestureDetector(
              onTap: () async {
                FirebaseFirestore.instance
                    .collection('staffmessage')
                    .get()
                    .then((value) {
                  final email = value.docs.first;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserMessages(
                                email: email['email'],
                                name: 'Computer Village ',
                                photo: '',
                                myEmail: cuser.email
                              )));
                });
              },
              child: AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.easeIn,
                margin: EdgeInsets.only(right: 80),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Contact staff',
                  style: GoogleFonts.k2d(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
