import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/models/intern_model.dart';
import 'package:cv/screens/dashboard/internship_detail.dart';
import 'package:flutter/material.dart';
import 'package:cv/constants.dart';
import 'package:google_fonts/google_fonts.dart';

final interReference = FirebaseFirestore.instance.collection('internship');

class InternDash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage applications'),
        backgroundColor: Color(
          0xFFA2200A,
        ),
      ),
      body: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder<QuerySnapshot>(
          stream: interReference.orderBy('time', descending: true).snapshots(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(
                    0xFFA2200A,
                  ),
                ),
              );
            }
            final data = snapshot.data.docs;
            int total = data.length;
            List<GestureDetector> _list = data.map((e) {
              InternAppli appli = InternAppli(
                  name: e['name'],
                  email: e['email'],
                  town: e['town'],
                  field: e['field'],
                  phone: e['phone'],
                  school: e['school'],
                  status: e['status'],
                  seen: e['seen'],
                  id: e.id,
                  useriD: e['userId']);
              return GestureDetector(
                onTap: () async {
                  await interReference
                      .doc(e.id)
                      .update({'seen': true}).catchError((error) {
                    print(error);
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InternDetail(
                                appli: appli,
                              )));
                },
                child: Container(
                  color: Colors.grey[100],
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: ListTile(
                    title: Text(
                      appli.name,
                      style: klabelStyle,
                    ),
                    subtitle: Text(appli.field),
                    trailing: CircleAvatar(
                      backgroundColor:
                          appli.seen ? Colors.transparent : Colors.red,
                      radius: 15,
                      child: Text(
                        appli.seen ? 'Seen' : 'New',
                        style: GoogleFonts.k2d(
                            color: appli.seen ? Colors.black : Colors.white,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
              );
            }).toList();
            return Container(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Total applications: $total',
                      style: kTextTitle2,
                    ),
                  ),
                  Divider(),
                  ..._list
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
