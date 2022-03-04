import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sender;
  final String reciever;
  final String content;
  final Timestamp time;
  Message({
    this.reciever,
    this.sender,
    this.content,
    this.time,
  });

  // factory Message.fromDocument(DocumentSnapshot doc) {
  //   return Message(
  //     content: doc.data()['message'],
  //     sender: doc.data()['message'],
  //     reciever: doc.data()['message'],
  //     time: doc.data()['message'],
  //   );
  // }
}
