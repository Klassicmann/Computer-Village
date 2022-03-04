import 'package:cloud_firestore/cloud_firestore.dart';

class WorkModel {
  final String name;
  final String desc;
  final String userId;
  final String phone;
  final Timestamp time;
  final bool seen;
  final bool status;
  final String id;
  WorkModel(
      {this.seen,
      this.status,
      this.name,
      this.desc,
      this.id,
      this.userId,
      this.phone,
      this.time});
}
