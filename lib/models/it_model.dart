class ITAppli {
  final String name;
  final String email;
  final String nationality;
  final String gender;
  final String field;
  final String school;
  final String town;
  final String quater;
  final String phone;
  final bool status;
  final bool seen;
  final String id;
  final String useriD;
  ITAppli(
      {this.name,
      this.email,
      this.nationality,
      this.gender,
      this.field,
      this.school,
      this.town,
      this.quater,
      this.phone,
      this.status,
      this.useriD,
      this.seen, this.id});

  factory ITAppli.fromDocument(e) {
    return ITAppli(
        name: e['name'],
        email: e['email'],
        town: e['town'],
        quater: e['quater'],
        nationality: e['nationality'],
        gender: e['gender'],
        field: e['field'],
        phone: e['phone'],
        school: e['school'],
        seen: e['seen'],
        status: e['status'],
        useriD: e['userId'],
        id: e.id);
  }
}
