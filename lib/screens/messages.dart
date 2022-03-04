import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/widgets/funtions.dart';
import 'package:cv/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class UserMessages extends StatefulWidget {
  final String email;
  final String name;
  final String photo;
  final String myEmail;
  UserMessages({this.email, this.name, this.photo, this.myEmail});

  @override
  _UserMessagesState createState() => _UserMessagesState();
}

class _UserMessagesState extends State<UserMessages> {
  final _mess = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FirebaseFirestore.instance.collection('messages').get().then((value) {
          value.docs.forEach((e) {
            if ((e['sender'] == widget.email &&
                    e['receiver'] == widget.myEmail) ||
                (e['sender'] == widget.myEmail &&
                    e['receiver'] == widget.email)) {
              if (!e['seen']) {
                FirebaseFirestore.instance
                    .collection('messages')
                    .doc(e.id)
                    .update({'seen': true});
              }
            }
          });
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [IconButton(icon: Icon(LineIcons.phone), onPressed: () {})],
          backgroundColor: Colors.blueGrey,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                  child: Icon(LineIcons.arrowLeft),
                  onTap: () => Navigator.pop(context)),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: CircleAvatar(
                    backgroundImage: widget.photo != ""
                        ? NetworkImage(widget.photo)
                        : AssetImage('assets/images/logo.jpg'),
                  )),
              SizedBox(
                width: 10,
              ),
              Text(widget.name)
            ],
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AllMessages(
                email: widget.email,
                myEmail: widget.myEmail,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5, left: 7, right: 7),
                padding: EdgeInsets.only(left: 10),
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _mess,
                        style: GoogleFonts.k2d(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type your message here',
                            hintStyle: GoogleFonts.k2d(color: Colors.white70)),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (widget.email != widget.myEmail) {
                            FirebaseFirestore.instance
                                .collection('messages')
                                .add({
                              'content': _mess.text.trim(),
                              'time': DateTime.now(),
                              'sender': widget.myEmail,
                              'receiver': widget.email,
                              'seen': false,
                              'status': false,
                            }).then((value) {
                              _mess.clear();
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                          'You cannot send message to yourself'),
                                    ),
                                  );
                                });
                          }
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

final messRef = FirebaseFirestore.instance.collection('messages');

class AllMessages extends StatelessWidget {
  final String email;
  final String myEmail;

  const AllMessages({this.email, this.myEmail});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder<QuerySnapshot>(
            stream: messRef.orderBy('time', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Progress();
              }

              final snaps = snapshot.data.docs;
              List allMessages = [];

              snaps.forEach((e) {
                if ((e['sender'] == email && e['receiver'] == myEmail) ||
                    (e['sender'] == myEmail && e['receiver'] == email)) {
                  allMessages.add(e);
                }
              });

              List messages = allMessages.map((e) {
                bool isMe = e['sender'] == myEmail;
                Timestamp _time = e['time'];

                DateTime time = DateTime.fromMicrosecondsSinceEpoch(
                    _time.microsecondsSinceEpoch);

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: ChatBubble(
                      shadowColor: Colors.black38,
                      margin: EdgeInsets.only(
                          top: 5, bottom: 10, left: 10, right: 10),
                      backGroundColor: isMe
                          ? Theme.of(context).accentColor.withOpacity(0.9)
                          : Colors.grey[200],
                      clipper: ChatBubbleClipper1(
                          type: isMe
                              ? BubbleType.sendBubble
                              : BubbleType.receiverBubble),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            e['content'],
                            style: GoogleFonts.k2d(
                                color: isMe ? Colors.white : Colors.black,
                                fontSize: 16),
                          ),
                          Text(
                            checktime(time),
                            style: GoogleFonts.k2d(
                                color: isMe ? Colors.white70 : Colors.black54,
                                fontSize: 10),
                          ),
                        ],
                      ),
                    )),
                  ],
                );
              }).toList();
              messages.reversed;
              return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, int index) {
                    return messages[index];
                  });
            }));
  }
}
