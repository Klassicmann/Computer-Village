import 'package:cloud_firestore/cloud_firestore.dart';

class Cuser {
  final String fullName;
  final String email;
  final String address;
  final String bio;
  final String photoUrl;
  final Timestamp createdDate;
  final String school;
  final String phone;
  final String id;
  final String work;
  final DocumentReference reference;
  Cuser(
      {this.fullName,
      this.email,
      this.address,
      this.bio,
      this.photoUrl,
      this.work,
      this.createdDate,
      this.school,
      this.phone,
      this.reference,
      this.id});
}
