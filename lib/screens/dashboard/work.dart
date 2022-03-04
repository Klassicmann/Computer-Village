import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/models/workmodel.dart';
import 'package:cv/screens/dashboard/work_detail.dart';
import 'package:flutter/material.dart';

import 'package:cv/constants.dart';
import 'package:google_fonts/google_fonts.dart';

final workReference = FirebaseFirestore.instance.collection('work');

class Allworks extends StatelessWidget {
  // const TrainningDash({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Requests'),
        backgroundColor: Color(
          0xFF00200A,
        ),
      ),
      body: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder<QuerySnapshot>(
          stream: workReference.orderBy('time', descending: true).snapshots(),
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
              WorkModel work = WorkModel(
                  name: e['name'],
                  phone: e['phone'],
                  desc: e['description'],
                  seen: e['seen'],
                  id: e.id,
                  status: e['status'],
                  userId: e['userId']);
              return GestureDetector(
                onTap: () async {
                  await workReference
                      .doc(e.id)
                      .update({'seen': true}).catchError((error) {
                    print(error);
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkDetail(
                                work: work,
                              )));
                },
                child: Container(
                  color: work.seen ? Colors.grey[100]:Colors.grey[200] ,
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: ListTile(
                    
                    title: Text(
                      work.name,
                      style: klabelStyle,
                    ),
                    subtitle: Text(work.desc),
                    trailing: CircleAvatar(
                      backgroundColor:
                          work.seen ? Colors.transparent : Colors.red,
                      radius: 15,
                      child: Text(
                        work.seen ? 'Seen' : 'New',
                        style: GoogleFonts.k2d(
                            color: work.seen ? Colors.black : Colors.white,
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
                      'All requests: $total',
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
