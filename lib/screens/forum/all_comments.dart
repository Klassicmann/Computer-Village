import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/models/user_model.dart';
import 'package:cv/widgets/dialogs.dart';
import 'package:cv/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final forum = FirebaseFirestore.instance.collection('forum');

class AllComments extends StatefulWidget {
  final String commentId;
  AllComments({this.commentId, this.cuser});
  final Cuser cuser;

  @override
  _AllCommentsState createState() => _AllCommentsState();
}

class _AllCommentsState extends State<AllComments> {
  final _rep = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context)),
        ],
        title: Text('Forum'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('forum')
                  .doc(widget.commentId)
                  .snapshots(),
              // initialData: (),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return Progress();
                }

                final data = snapshot.data;

                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        // padding: EdgeInsets.all(5),

                        child: ListTile(
                          leading: CircleAvatar(
                            // backgroundColor: Colors.black,
                            backgroundImage: data['photoUrl'] != ""
                                ? NetworkImage(data['photoUrl'])
                                : AssetImage('assets/images/logo.jpg'),
                            radius: 30,
                          ),
                          title: Text(
                            data['username'],
                            style: GoogleFonts.k2d(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          subtitle: Text(
                            data['content'],
                            style: GoogleFonts.k2d(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      Riplies(id: data.id,)
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            // color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                Container(
                  height: 60,
                  decoration:
                      BoxDecoration(color: Theme.of(context).accentColor),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _rep,
                            keyboardType: TextInputType.multiline,
                            style: GoogleFonts.k2d(
                                color: Colors.white, fontSize: 19),
                            maxLines: 5,
                            decoration: InputDecoration(
                                hintText: 'Reply',
                                hintStyle:
                                    GoogleFonts.k2d(color: Colors.white)),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.send_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              if (_rep.text.isNotEmpty) {
                                FirebaseFirestore.instance.collection('forum').doc(widget.commentId)
                                    .collection('forumReplies')
                                    .add({
                                  'username': widget.cuser.fullName,
                                  'question': widget.commentId,
                                  'id': widget.cuser.id,
                                  'photoUrl': widget.cuser.photoUrl,
                                  'reply': _rep.text.trim(),
                                  'time': DateTime.now(),
                                  'LikeList': [],
                                }).whenComplete(() {
                                  // forumSnackbar(context);

                                  setState(() {
                                    _rep.clear();
                                  });
                                }).catchError((error) {
                                  print(error);
                                });
                              }
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Riplies extends StatelessWidget {
  final String id;

   Riplies({this.id}) ;
  @override
  Widget build(BuildContext context) {
    
        return Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('forum').doc(id).collection('forumReplies').orderBy('time', descending: true).snapshots(),
              builder: (context, replydata) {
                if (!replydata.hasData) {
                  return Progress();
                }

                List replies = replydata.data.docs.map((reply) {
                  return Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(color: Colors.grey[100]),
                        child: ListTile(
                          leading: CircleAvatar(
                            // backgroundColor: Colors.black,
                            backgroundImage: reply['photoUrl'] != ""
                                ? NetworkImage(reply['photoUrl'])
                                : AssetImage('assets/images/logo.jpg'),
                            radius: 25,
                          ),
                          title: Text(
                            reply['username'],
                            style: GoogleFonts.k2d(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          subtitle: Text(
                            reply['reply'],
                            style: GoogleFonts.k2d(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList();

                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 30),
                    // height: MediaQuery.of(context).size.height / 1.4,
                    child: ListView(
                      children: [
                        ...replies,
                      ],
                    ),
                  ),
                );
              }),
        
      
    );
  }
}
