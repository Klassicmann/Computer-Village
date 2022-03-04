import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/models/user_model.dart';
import 'package:cv/screens/forum/all_comments.dart';
import 'package:cv/widgets/dialogs.dart';
import 'package:cv/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final forum = FirebaseFirestore.instance.collection('forum');

class Forum extends StatefulWidget {
  final Cuser cuser;
  Forum({this.cuser});

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  final _quest = TextEditingController();
  bool loading = false;
  bool reply = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Forum'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context))
        ],
      ),
      // resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[200],
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Container(
          // color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              Expanded(child: ForumQuestions(cuser: widget.cuser)),
              Container(
                height: 60,
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _quest,
                          keyboardType: TextInputType.multiline,
                          style: GoogleFonts.k2d(
                              color: Colors.white, fontSize: 19),
                          maxLines: 5,
                          decoration: InputDecoration(
                              hintText: 'Ask a question',
                              hintStyle: GoogleFonts.k2d(color: Colors.white)),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.send_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            if (_quest.text.isNotEmpty) {
                              setState(() {
                                loading = true;
                              });

                              await forum.add({
                                'email': widget.cuser.email,
                                'username': widget.cuser.fullName,
                                'id': widget.cuser.id,
                                'photoUrl': widget.cuser.photoUrl,
                                'content': _quest.text.trim(),
                                'time': DateTime.now(),
                                'LikeList': [],
                                'comments': 0
                              }).whenComplete(() {
                                forumSnackbar(context);

                                setState(() {
                                  _quest.clear();
                                  loading = false;
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
      ),
    );
  }
}

class ForumQuestions extends StatefulWidget {
  final Cuser cuser;
  const ForumQuestions({this.cuser});

  @override
  _ForumQuestionsState createState() => _ForumQuestionsState();
}

class _ForumQuestionsState extends State<ForumQuestions> {
  bool showReply = false;
  final _rep = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: forum.orderBy('time', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            );
          }
          final data = snapshot.data.docs;
          List<Container> allQuests = data.map((e) {
            List likes = e['LikeList'];
            int comments = e['comments'];

            return Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.grey[100]),
                    child: Column(
                      children: [
                        Container(
                          // padding: EdgeInsets.all(5),
                          child: ListTile(
                            leading: CircleAvatar(
                              // backgroundColor: Colors.black,
                              backgroundImage: e['photoUrl'] != ""
                                  ? NetworkImage(e['photoUrl'])
                                  : AssetImage('assets/images/logo.jpg'),
                              radius: 30,
                            ),
                            title: Text(
                              e['username'],
                              style: GoogleFonts.k2d(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                            subtitle: Text(
                              e['content'],
                              style: GoogleFonts.k2d(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                            trailing:e['email'] == FirebaseAuth.instance.currentUser.email?
                             IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Dou you want to delete this post?'),
                                                actions: [
                                                  MaterialButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      color: Colors.lightBlue,
                                                      child: Text('Cancel',
                                                          style:
                                                              GoogleFonts.k2d(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white))),
                                                  MaterialButton(
                                                      onPressed: () async {
                                                        
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('forum')
                                                            .doc(e.id)
                                                            .delete()
                                                            .whenComplete(() =>
                                                                Navigator.pop(
                                                                    context))
                                                            .catchError(
                                                                (error) {
                                                          print(error);
                                                        });
                                                      },
                                                      color: Colors.redAccent,
                                                      child: Text('Delete',
                                                          style:
                                                              GoogleFonts.k2d(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white)))
                                                ],
                                              );
                                            });
                                      }): Container(width: 1,) ),
                          ),
                        
                        Container(
                          padding: EdgeInsets.only(left: 60),
                          // decoration: BoxDecoration(color: Colors.grey[100]),

                          child: Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  final loggedinUser =
                                      FirebaseAuth.instance.currentUser.email;
                                  if (!likes.contains(loggedinUser)) {
                                    likes.add(loggedinUser.toString());
                                    forum.doc(e.id).update({
                                      'LikeList': likes,
                                    }).catchError((error) {
                                      print(error);
                                    });
                                  } else {
                                    likes.removeWhere(
                                        (element) => element == loggedinUser);
                                    forum
                                        .doc(e.id)
                                        .update({'LikeList': likes}).catchError(
                                            (error) {
                                      print(error);
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.thumbsUp,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      likes.length.toString(),
                                      style: GoogleFonts.k2d(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    showReply = !showReply;
                                  });
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 60,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: _rep,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: GoogleFonts.k2d(
                                                      color: Colors.black,
                                                      fontSize: 19),
                                                  maxLines: 5,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.all(0),
                                                      hintText: 'Reply here',
                                                      hintStyle:
                                                          GoogleFonts.k2d(
                                                              color: Colors
                                                                  .black54)),
                                                ),
                                              ),
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.send_outlined,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    if (_rep.text.isNotEmpty) {
                                                      FirebaseFirestore.instance
                                                          .collection('forum')
                                                          .doc(e.id)
                                                          .collection(
                                                              'forumReplies')
                                                          .add({
                                                        'username': widget
                                                            .cuser.fullName,
                                                        'question': e.id,
                                                        'id': widget.cuser.id,
                                                        'photoUrl': widget
                                                            .cuser.photoUrl,
                                                        'reply':
                                                            _rep.text.trim(),
                                                        'time': DateTime.now(),
                                                        'likeList': [],
                                                      }).whenComplete(() {
                                                        forum.doc(e.id).update({
                                                          'comments':
                                                              comments + 1
                                                        });
                                                        setState(() {
                                                          _rep.clear();
                                                        });
                                                      }).catchError((e) {
                                                        print(e);
                                                      });
                                                    }
                                                  })
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.comment,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      comments.toString(),
                                      style: GoogleFonts.k2d(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('forum')
                          .doc(e.id)
                          .collection('forumReplies')
                          .orderBy('time', descending: true)
                          .snapshots(),
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
                                decoration:
                                    BoxDecoration(color: Colors.grey[100]),
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
                        List<dynamic> list2 = [];
                        if (replies.length <= 2) {
                          list2 = replies;
                        } else {
                          list2 = replies.sublist(0, 2);
                        }
                        return Container(
                          margin: EdgeInsets.only(left: 30),
                          height: list2.length * 100.0,
                          child: ListView(
                            children: [
                              ...list2,
                              list2.length >= 2
                                  ? MaterialButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AllComments(
                                                  commentId: e.id,
                                                  cuser: widget.cuser))),
                                      child: Text(
                                        'View all comments',
                                        style: GoogleFonts.k2d(
                                            color: Colors.lightBlue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            );
          }).toList();
          return Container(
            child: ListView(
              children: [...allQuests],
            ),
          );
        });
  }
}
