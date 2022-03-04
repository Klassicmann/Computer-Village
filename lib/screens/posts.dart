import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/models/user_model.dart';
import 'package:cv/screens/full_image.dart';
import 'package:cv/screens/messages.dart';
import 'package:cv/screens/other_user_profile.dart';
import 'package:cv/screens/profile.dart';
import 'package:cv/widgets/funtions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:social_share/social_share.dart';

CollectionReference postsref = FirebaseFirestore.instance.collection('posts');
CollectionReference usersref = FirebaseFirestore.instance.collection('users');
CollectionReference commentsref =
    FirebaseFirestore.instance.collection('comments');

class Posts extends StatefulWidget {
  final Cuser cuser;
  final int id;

  const Posts({this.id, this.cuser});

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  bool liked = false;
  final postLikeRefernce = FirebaseFirestore.instance.collection('postLikes');

  bool loggedInUserLiked = false;

  @override
  Widget build(BuildContext context) {
    String useremail = FirebaseAuth.instance.currentUser.email;

    return Container(
      color: Colors.grey[100],
      child: StreamBuilder<QuerySnapshot>(
          stream: postsref.orderBy('time', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              );
            }
            final data = snapshot.data.docs;
            List<Widget> _posts = data.map((e) {
              String title = e['title'];
              String desc = e['desc'];
              String img = e['image'];
              DocumentReference _user = e['user'];
              Timestamp ptime = e['time'];
              int saved = e['saved'];
              int shares = e['shares'];
              DateTime time = DateTime.fromMillisecondsSinceEpoch(
                  ptime.millisecondsSinceEpoch);
              List<dynamic> likelist = e['LikeList'];

              return StreamBuilder<DocumentSnapshot>(
                  stream: usersref.doc(_user.id).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: Container(
                        margin: EdgeInsets.only(top: 30),
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blueGrey,
                        ),
                      ));
                    }
                    final posted_by = snapshot.data;

                    Cuser _cuser = Cuser(
                        fullName: posted_by['Full name'],
                        email: posted_by['Email'],
                        phone: posted_by['Phone Number'],
                        address: posted_by['Town'],
                        school: posted_by['School'],
                        photoUrl: posted_by['PhotoUrl'],
                        bio: posted_by['Bio'],
                        createdDate: posted_by['Created date'],
                        reference: posted_by.reference,
                        id: posted_by.id);

                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              leading: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image(
                                    image: posted_by['PhotoUrl'] != ""
                                        ? NetworkImage(posted_by['PhotoUrl'])
                                        : AssetImage('assets/images/logo.jpg'),
                                    width: 55,
                                    height: 60,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              title: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtherUserProfile(
                                              cuser: _cuser,
                                            ))),
                                child: Text(
                                  posted_by['Full name'],
                                  style: GoogleFonts.k2d(
                                      fontSize: 18,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.clock,
                                    size: 14,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(checktime(time)),
                                ],
                              ),
                              trailing: posted_by['Email'] != useremail
                                  ? Container(
                                      width: 1,
                                    )
                                  // ? IconButton(
                                  //     onPressed: () => Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (context) =>
                                  //                 UserMessages(
                                  //                   email: posted_by['Email'],
                                  //                   name:
                                  //                       posted_by['Full name'],
                                  //                   photo:
                                  //                       posted_by['PhotoUrl'],
                                  //                 ))),
                                  //     icon: Icon(
                                  //       Icons.message_outlined,
                                  //       size: 25,
                                  //     ),
                                  //   )
                                  : IconButton(
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
                                                        if (img != '') {
                                                          await FirebaseStorage
                                                              .instance
                                                              .refFromURL(img)
                                                              .delete();
                                                        }
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('posts')
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
                                      })),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              title,
                              style: GoogleFonts.k2d(
                                  color: Colors.black,
                                  fontSize: title != "" ? 19 : 0),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 3),
                            child: Text(
                              desc,
                              style: GoogleFonts.abel(
                                color: Colors.black87,
                                fontSize: desc != "" ? 18 : 0,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => img != ''
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullImage(
                                              image: img,
                                              url: true,
                                            )))
                                : null,
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  maxHeight: img != '' ? 400 : 0,
                                ),
                                child: img != ''
                                    ? Image(
                                        image: NetworkImage(img),
                                        fit: BoxFit.cover,
                                      )
                                    : Container()),
                          ),
                          Divider(
                            height: 7,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                PostIcon(
                                    icon: FontAwesomeIcons.thumbsUp,
                                    text: likelist.length.toString(),
                                    userLiked: loggedInUserLiked,
                                    ontap: () {
                                      final loggedinUser = FirebaseAuth
                                          .instance.currentUser.email;
                                      if (!likelist.contains(loggedinUser)) {
                                        setState(() {
                                          loggedInUserLiked = true;
                                        });
                                        likelist.add(loggedinUser.toString());
                                        postsref.doc(e.id).update({
                                          'LikeList': likelist,
                                        }).catchError((error) {
                                          print(error);
                                        });
                                      } else {
                                        setState(() {
                                          loggedInUserLiked = false;
                                        });
                                        likelist.removeWhere((element) =>
                                            element == loggedinUser);
                                        postsref.doc(e.id).update({
                                          'LikeList': likelist
                                        }).catchError((error) {
                                          print(error);
                                        });
                                      }
                                    }),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CommentList(
                                              userImage: widget.cuser.photoUrl,
                                              userName: widget.cuser.fullName,
                                              post: e.id,
                                              userReference:
                                                  posted_by.reference,
                                              email: widget.cuser.email);
                                        });
                                  },
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: commentsref
                                          .where('post', isEqualTo: e.id)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return CircularProgressIndicator();
                                        }
                                        final commentList =
                                            snapshot.data.docs.length;

                                        return PostIcon(
                                          icon: FontAwesomeIcons.comment,
                                          text: commentList.toString(),
                                        );
                                      }),
                                ),
                                PostIcon(
                                    icon: FontAwesomeIcons.share,
                                    text: shares.toString(),
                                    ontap: () async =>
                                        await SocialShare.shareTwitter(desc,
                                            hashtags: [
                                              'ComputerVillage, Cameroon, Douala'
                                            ],
                                            url: '',
                                            trailingText: 'Computer Village')),
                                PostIcon(
                                  icon: LineIcons.save,
                                  text: saved.toString(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            height: 10,
                            thickness: 10,
                          ),
                        ],
                      ),
                    );
                  });
            }).toList();
            return ListView(
              children: [
                !FirebaseAuth.instance.currentUser.emailVerified
                    ? GreetUser()
                    : Container(),
                Center(
                  child: Container(
                    // decoration: BoxDecoration(color: colrosb),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      'Latest posts',
                      style: GoogleFonts.k2d(
                          color: Colors.black54, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                ..._posts
              ],
            );
          }),
    );
  }
}

class CommentList extends StatefulWidget {
  final String post;
  final String userName;
  final String userImage;
  final DocumentReference userReference;
  final String email;

  CommentList(
      {this.post,
      this.userName,
      this.userImage,
      this.userReference,
      this.email});
  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  final commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(widget.userName);
    return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            height: 500,
            decoration: BoxDecoration(color: Colors.blueGrey[200]),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('comments')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blueGrey,
                      ),
                    );
                  }
                  final data = snapshot.data.docs;
                  List<Widget> _posts = data.map((e) {
                    if (e['post'] == widget.post) {
                      return SingleComment(
                        image: e['user image'],
                        likes: e['likes'],
                        username: e['user'],
                        comment: e['comment'],
                        postId: e.id,
                      );
                    }
                    return Container();
                  }).toList();
                  return ListView(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    children: [
                      // Container(
                      //   margin: EdgeInsets.symmetric(horizontal: 20),
                      //   child: Text(
                      //     'Showing from most recent comment',
                      //     style: GoogleFonts.k2d(fontSize: 15),
                      //   ),
                      // ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: commentController,
                                enableSuggestions: true,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    // border: OutlineInputBorder(
                                    //     borderSide:
                                    //         BorderSide(color: Colors.white)),
                                    hintText: 'Enter your comment here',
                                    hintStyle: GoogleFonts.k2d(
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            IconButton(
                                icon:
                                    Icon(Icons.send, color: Colors.deepOrange),
                                onPressed: () {
                                  if (commentController.text.trim() != '') {
                                    FirebaseFirestore.instance
                                        .collection('comments')
                                        .add({
                                      'comment': commentController.text.trim(),
                                      'post': widget.post,
                                      'user': widget.userName,
                                      'likes': 0,
                                      'user image': widget.userImage,
                                      'time': DateTime.now(),
                                      'user email': widget.email
                                    }).then((value) {
                                      commentController.clear();
                                    }).catchError((error) {
                                      print(error);
                                    });
                                  }
                                })
                          ],
                        ),
                      ),
                      ..._posts
                    ],
                  );
                }),
          );
        });
  }
}

class SingleComment extends StatefulWidget {
  final String comment;
  final String username;
  final String image;
  final int likes;
  final String postId;
  SingleComment(
      {this.comment, this.username, this.image, this.likes, this.postId});

  @override
  _SingleCommentState createState() => _SingleCommentState();
}

class _SingleCommentState extends State<SingleComment> {
  bool liked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: widget.image != ''
              ? NetworkImage(widget.image)
              : AssetImage('assets/images/logo.jpg'),
        ),
        title: Text(widget.username,
            style: GoogleFonts.k2d(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(widget.comment,
            style: GoogleFonts.k2d(
              fontSize: 14,
            )),
        trailing: GestureDetector(
          onTap: () async {
            setState(() {
              liked = !liked;
            });
            await FirebaseFirestore.instance
                .collection('comments')
                .doc(widget.postId)
                .update({
              'likes': liked
                  ? widget.likes + 1
                  : widget.likes != 0
                      ? widget.likes - 1
                      : 0
            });
          },
          child: Column(
            children: [
              Icon(
                FontAwesomeIcons.thumbsUp,
                size: 18,
              ),
              SizedBox(
                height: 2,
              ),
              Text(widget.likes.toString(),
                  style: GoogleFonts.k2d(fontSize: 12))
            ],
          ),
        ),
      ),
    );
  }
}

class GreetUser extends StatefulWidget {
  @override
  _GreetUserState createState() => _GreetUserState();
}

class _GreetUserState extends State<GreetUser> {
  bool sent = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(80)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 01,
                spreadRadius: 0.4,
                color: Colors.grey)
          ]),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sent
                ? 'An email confirmation link was sent to your mail box. It expires after 10 minutes'
                : 'You have not confirm your email ',
            style: GoogleFonts.k2d(fontSize: 15, color: Colors.black87),
          ),
          GestureDetector(
            onTap: () => FirebaseAuth.instance.currentUser
                .sendEmailVerification()
                .whenComplete(() {
              setState(() {
                sent = true;
              });
            }),
            child: Text(
              'Resend link',
              style: GoogleFonts.k2d(fontSize: 15, color: Colors.lightBlue),
            ),
          )
        ],
      ),
    );
  }
}

class PostIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function ontap;
  const PostIcon({this.icon, this.text, this.ontap, this.userLiked = false});
  final bool userLiked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        children: [
          Icon(
            icon,
            color: userLiked ? Colors.deepOrange : Colors.black54,
            size: 18,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: GoogleFonts.k2d(
              color: userLiked ? Colors.deepOrange : Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}
