import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/screens/add_files.dart';
import 'package:cv/screens/dashboard/create_post.dart';
import 'package:cv/screens/dashboard/internship.dart';
import 'package:cv/screens/dashboard/trainning.dart';
import 'package:cv/screens/dashboard/users.dart';
import 'package:cv/screens/dashboard/work.dart';
import 'package:cv/screens/my_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class DrawerBuilder extends StatefulWidget {
  @override
  _DrawerBuilderState createState() => _DrawerBuilderState();
}

class _DrawerBuilderState extends State<DrawerBuilder> {
  bool itBool = false;
  bool internshipBool = false;

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final _users = snapshot.data.docs;
          DocumentReference _reference;
          _users.forEach((element) {
            if (element['Email'] == user.email) {
              _reference = element.reference;
            }
          });
          
          return Container(
            width: MediaQuery.of(context).size.width / 2.1,
            color: Colors.blueGrey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 100,
                    child: Stack(
                      children: [
                        Image(
                          image: AssetImage(
                            'assets/images/logo.jpg',
                          ),
                          fit: BoxFit.cover,
                          height: 170,
                          width: double.infinity,
                        ),
                        // Positioned(
                        //     bottom: 0,
                        //     left: 0,
                        //     child: Container(
                        //         padding: EdgeInsets.all(10),
                        //         width: MediaQuery.of(context).size.width / 1.4,
                        //         color: Colors.black54,
                        //         child: Text('Klassic Mann',
                        //             style: GoogleFonts.k2d(
                        //                 fontSize: 20, color: Colors.white)))),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 10),
                //   child: Text('Admin Area', style: GoogleFonts.k2d(
                //     color: Colors.white
                //   ),),
                // ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CreatPost(reference: _reference,);
                            })),
                            child: DrawerListItems(
                              icon: LineIcons.podcast,
                              title: 'Posts',
                            ),
                          ),
                          Divider(
                            height: 0.4,
                            color: Colors.black54,
                            indent: 2,
                          ),
                          // GestureDetector(
                          //   onTap: () => Navigator.push(context,
                          //       MaterialPageRoute(builder: (context) {
                          //     return Container();
                          //   })),
                          //   child: DrawerListItems(
                          //     icon: LineIcons.wrench,
                          //     title: 'Services',
                          //   ),
                          // ),
                          Divider(
                            height: 0.4,
                            color: Colors.black54,
                            indent: 1,
                            thickness: 0.1,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ManageUsers();
                            })),
                            child: DrawerListItems(
                              icon: LineIcons.users,
                              title: 'Users',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return TrainningDash();
                            })),
                            child: DrawerListItems(
                              icon: LineIcons.userGraduate,
                              title: 'I.T Training',
                              
                            ),
                          ),
                          Divider(
                            height: 0.4,
                            color: Colors.black54,
                            indent: 2,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return InternDash();
                            })),
                            child: DrawerListItems(
                              icon: Icons.school,
                              title: 'Intership',
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black54,
                            indent: 3,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Allworks();
                            })),
                            child: DrawerListItems(
                              icon: LineIcons.handHolding,
                              title: 'Work ',
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black54,
                            indent: 3,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Container();
                            })),
                            child: DrawerListItems(
                              icon: LineIcons.readme,
                              title: 'Jobs',
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black54,
                            indent: 3,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Container();
                            })),
                            child: DrawerListItems(
                              icon: LineIcons.plane,
                              title: 'Study Abroad',
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black54,
                            indent: 3,
                          ),
                          // GestureDetector(
                          //   onTap: () => Navigator.push(context,
                          //       MaterialPageRoute(builder: (context) {
                          //     return Container();
                          //   })),
                          //   child: DrawerListItems(
                          //     icon: LineIcons.shoppingBag,
                          //     title: 'Business',
                          //   ),
                          // ),
                          Divider(
                            height: 1,
                            color: Colors.black54,
                            indent: 3,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AddFiles();
                            })),
                            child: DrawerListItems(
                              icon: LineIcons.file,
                              title: 'Files',
                            ),
                          ),
                          Divider(
                            height: 0.4,
                            color: Colors.black54,
                            indent: 2,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Container();
                            })),
                            child: DrawerListItems(
                              icon: LineIcons.shopware,
                              title: 'Shop',
                            ),
                          ),

                          Divider(
                            height: 0.4,
                            color: Colors.black54,
                            indent: 2,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyMessages())),
                            child: DrawerListItems(
                              icon: LineIcons.facebookMessenger,
                              title: 'Messages',
                            ),
                          ),
                          
                          Divider(
                            height: 0.4,
                            color: Colors.black54,
                            indent: 2,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          );
        });
  }
}

class DrawerListItems extends StatelessWidget {
  DrawerListItems({this.icon, this.title, this.tap});
  final IconData icon;
  final String title;
  final Function tap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        margin: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Icon(
                icon,
                size: 26,
                color: Color(0xFAA09FB8),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(title,
                  style: GoogleFonts.k2d(fontSize: 20, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

class SignalButton extends StatelessWidget {
  final IconData icon;
  final int numb;
  final bool home;
  SignalButton({this.icon, this.numb, this.home = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Stack(
        children: [
          IconButton(
              icon: Icon(
                icon,
                color: home ? Colors.white : Colors.white,
                size: 25,
              ),
              onPressed: () {}),
          Positioned(
            top: 10,
            right: 10,
            child: numb != null
                ? Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      numb.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 10),
                    ),
                  )
                : Text(''),
          )
        ],
      ),
    );
  }
}
