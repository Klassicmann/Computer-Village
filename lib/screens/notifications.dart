import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notifications extends StatelessWidget {
  final String id;
  final List notifs;
  Notifications({this.id, this.notifs});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Notifications'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(id)
                .collection('notifications').orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueGrey,
                  ),
                );
              }
              List allNotifs = snapshot.data.docs.map((e) {
                String title = e['title'];
                String content = e['content'];
                // String newContent = content.substring(0, 50);
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      // leading: CircleAvatar(
                      //   backgroundColor: Colors.black,
                      //   radius: 25,
                      // ),
                      title: Text(
                        title,
                        style: GoogleFonts.k2d(
                          fontSize: 19,
                          color: Colors.blueGrey
                        ),
                      ),
                      subtitle: Text(content != ''? content : '' ),
                    ),
                  ),
                );
              }).toList();
              return ListView(
                children: [...allNotifs],
              );
            }),
      ),
    );
  }
}
