class InternAppli {
  final String name;
  final String email;
  final String field;
  final String school;
  final String town;
  final String phone;
  final bool status;
  final bool seen;
  final String id;
  final String useriD;
  InternAppli(
      {this.name,
      this.email,
      this.field,
      this.school,
      this.town,
      this.phone,
      this.status,
      this.useriD,
      this.seen, this.id});

  factory InternAppli.fromDocument(e) {
    return InternAppli(
        name: e['name'],
        email: e['email'],
        town: e['town'],
        field: e['field'],
        phone: e['phone'],
        school: e['school'],
        seen: e['seen'],
        status: e['status'],
        useriD: e['userId'],
        id: e.id);
  }
}
