import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/constants.dart';
import 'package:cv/screens/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageUsers extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _user = FirebaseAuth.instance.currentUser.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Manage users'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                backgroundColor: Colors.orange,
              );
            }

            final _data = snapshot.data.docs;

            List<Widget> _allUsers = _data.map((e) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserMessages(name: e['Full name'],email: e['Email'], myEmail: _user, photo: e['PhotoUrl'],)));
                },
                child: ListTile(
                  title: Text(
                    e['Full name'],
                    style: klabelStyle.copyWith(fontSize: 19),
                  ),
                  subtitle: Text(
                    e['Email'],
                    style: klabelStyle.copyWith(
                        fontSize: 16, color: Colors.black54),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: e['PhotoUrl'] != ""
                        ? NetworkImage(e['PhotoUrl'])
                        : AssetImage('assets/images/logo.jpg'),
                  ),
                ),
              );
            }).toList();

            return Container(
              child: ListView(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    _data.length.toString() + ' users found',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 18,
                    ),
                  ),
                ),
                ..._allUsers
              ]),
            );
          },
        ),
      ),
    );
  }
}
