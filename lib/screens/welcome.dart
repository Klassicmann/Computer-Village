import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/models/user_model.dart';
import 'package:cv/screens/galery.dart';
import 'package:cv/screens/about_us.dart';
import 'package:cv/screens/notifications.dart';
import 'package:cv/screens/posts.dart';
import 'package:cv/screens/profile.dart';
import 'package:cv/screens/services.dart';
import 'package:cv/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class HomeScreen extends StatefulWidget {
  final int id;
  final Cuser cuser;
  final int notifs;
  final List emails;
  HomeScreen({this.id, this.cuser, this.notifs, this.emails});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    _controller = TabController(length: 4, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetsList = [
      Posts(
        id: 1,
        cuser: widget.cuser
      ),
      // Posts(),
      Services(
        cuser: widget.cuser,
      ),
      // Galery(),
      AboutUs(
        cuser: widget.cuser,
      ),
      Profile(
        cuser: widget.cuser,
      ),
    ];

    final _user = FirebaseAuth.instance.currentUser;
    final notifRefernce = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.cuser.id)
        .collection('notifications');
    return Scaffold(
        key: _scafoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: RichText(
            text: TextSpan(
                text: widget.id != null ? 'Welcome  ' : 'Welcome back  ',
                children: [
                  TextSpan(
                      text: widget.cuser.fullName,
                      style: GoogleFonts.aBeeZee(
                          color: Colors.deepOrange, fontSize: 17))
                ]),
          ),
          toolbarHeight: 35,
          actions: [
            StreamBuilder<QuerySnapshot>(
                stream: notifRefernce.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  }
                  List notifs = [];
                  snapshot.data.docs.forEach((element) {
                    if (!element['seen']) {
                      notifs.add(element);
                    }
                  });
                  return GestureDetector(
                    onTap: () async {
                      await notifRefernce.get().then((value) {
                        value.docs.forEach((element) {
                          notifRefernce.doc(element.id).update({'seen': true});
                        });
                      }).catchError((error) {
                        print(error);
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Notifications(
                                    id: widget.cuser.id,
                                    notifs: notifs,
                                  )));
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 20, top: 5),
                      // color: Colors.red,
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              LineIcons.bell,
                              size: 25,
                            ),
                          ),
                          Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: widget.notifs == 0
                                        ? Colors.transparent
                                        : Colors.red),
                                child: Text(
                                    widget.notifs == 0
                                        ? ''
                                        : widget.notifs.toString(),
                                    style: GoogleFonts.k2d(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ))
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
        drawer: widget.emails.contains(_user.email)
            ? Container(
                width: MediaQuery.of(context).size.width / 1.6,
                child: Drawer(
                  child: DrawerBuilder(),
                ),
              )
            : Container(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          padding: EdgeInsets.all(5),
          child: GNav(
            rippleColor:
                Colors.grey[800], // tab button ripple color when pressed
            hoverColor: Colors.grey[700], // tab button hover color
            haptic: true, // haptic feedback
            tabBorderRadius: 15,
            tabActiveBorder:
                Border.all(color: Colors.orange, width: 1), // tab button border
            tabBorder:
                Border.all(color: Colors.grey, width: 1), // tab button border
            tabShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
            ], // tab button shadow
            curve: Curves.easeOutExpo, // tab animation curves
            duration: Duration(milliseconds: 400), // tab animation duration
            gap: 8, // the tab button gap between icon and text
            color: Colors.grey[800], // unselected icon color
            activeColor: Colors.black, // selected icon and text color
            iconSize: 20, // tab button icon size
            tabBackgroundColor:
                Colors.purple.withOpacity(0.1), // selected tab background color
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: 5), // navigation bar padding
            tabs: [
              GButton(
                icon: LineIcons.podcast,
                text: 'Posts',
              ),
              GButton(
                icon: Icons.category_outlined,
                text: 'Services',
              ),
              // GButton(
              //   icon: FontAwesomeIcons.folder,
              //   text: 'Galery',
              // ),
              GButton(
                icon: LineIcons.question,
                text: 'Help',
              ),
              GButton(
                icon: LineIcons.user,
                text: 'Profile',
              )
            ],
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
        body: Container(child: _widgetsList[_selectedIndex]));
  }
}
