import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/auth/login.dart';
import 'package:cv/models/user_model.dart';
import 'package:cv/screens/full_image.dart';
import 'package:cv/screens/instermidiate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;

import '../constants.dart';

class Profile extends StatefulWidget {
  final Cuser cuser;
  Profile({this.cuser});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _imageFile;
  String imageUrl;

  final _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    PickedFile selected =
        await _picker.getImage(source: source, imageQuality: 75);

    File image;

    image = File(selected.path);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      print(croppedFile);
      setState(() {
        _imageFile = croppedFile;
      });

      Reference reference = FirebaseStorage.instance
          .ref('profile')
          .child('profileImages/${Path.basename(croppedFile.path)}');
      await reference.putFile(croppedFile).whenComplete(() {
        reference.getDownloadURL().then((url) {
          setState(() {
            imageUrl = url;
          });
          FirebaseFirestore.instance
              .collection('users')
              .doc(widget.cuser.id)
              .update({'PhotoUrl': url});
        });
      }).catchError((error) {
        print(error);
      });
    }
  }

  final _user = FirebaseAuth.instance.currentUser.email;
  @override
  Widget build(BuildContext context) {
    bool isMe = widget.cuser.email == _user;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.cuser.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          }
          return Container(
            color: Colors.grey[200],
            child: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                // pinned: true,
                floating: false,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blueGrey,
                expandedHeight: MediaQuery.of(context).size.height / 4,

                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                    left: 1,
                  ),
                  background: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FullImage(url: true,image: snapshot.data['PhotoUrl'],))),
                    child: Image(
                      image: snapshot.data['PhotoUrl'] != null
                          ? NetworkImage(snapshot.data['PhotoUrl'])
                          : AssetImage('assets/images/logo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(5))),
                    child: Text(
                      widget.cuser.fullName,
                      style: GoogleFonts.k2d(
                          // backgroundColor: Colors.black54
                          ),
                    ),
                  ),
                  centerTitle: false,
                ),
                actions: [
                  isMe
                      ? Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(30)),
                          child: IconButton(
                              icon: Icon(LineIcons.pen),
                              tooltip: 'change cover photo',
                              color: Colors.black87,
                              splashColor: Colors.red,
                              onPressed: () {
                                _pickImage(ImageSource.gallery);
                              }),
                        )
                      : Container(),
                ],
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Divider(
                  height: 10,
                  thickness: 7,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  // height: MediaQuery.of(context).size.height / 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Account',
                            style: GoogleFonts.abel(
                                fontSize: 20, color: Colors.blueGrey),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => EditProfileForm(
                                        user: widget.cuser,
                                      ));
                            },
                            child: isMe
                                ? Icon(
                                    LineIcons.pen,
                                    color: Colors.blueGrey,
                                  )
                                : Container(),
                          )
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      UserInfo(
                        icon: LineIcons.user,
                        title: 'Name',
                        content: widget.cuser.fullName,
                      ),
                      Divider(),
                      UserInfo(
                        icon: LineIcons.at,
                        title: 'Email',
                        content: widget.cuser.email,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            child: UserInfo(
                              icon: LineIcons.school,
                              title: 'School',
                              reduceFont: true,
                              content: widget.cuser.school != ''
                                  ? widget.cuser.school
                                  : 'add your school',
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: UserInfo(
                              icon: LineIcons.toolbox,
                              reduceFont: true,
                              title: 'Work',
                              content:
                                  widget.cuser.work != null? widget.cuser.work: 'Add your work'
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserInfo(
                            icon: LineIcons.locationArrow,
                            title: 'Town',
                            content: widget.cuser.address,
                          ),
                          UserInfo(
                            icon: LineIcons.phone,
                            title: 'Phone',
                            content: widget.cuser.phone != ''
                                ? widget.cuser.phone
                                : 'No phone number',
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      UserInfo(
                        icon: LineIcons.question,
                        title: 'Bio',
                        reduceFont: true,
                        content: widget.cuser.bio != ''
                            ? widget.cuser.bio
                            : 'Add short info about yourself so people get to know you better',
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(color: Colors.grey[100]),
                ),
                isMe
                    ? Container(
                        margin: EdgeInsets.only(left: 20, top: 20),
                        child: GestureDetector(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Confirm sign out'),
                                    actions: [
                                      MaterialButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Cancel',
                                          style: GoogleFonts.k2d(
                                              color: Colors.white),
                                        ),
                                        color: Colors.lightBlue,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context,
                                              true); // It worked for me instead of above line
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Login()),
                                          );
                                        },
                                        child: Text(
                                          'Signout',
                                          style: GoogleFonts.k2d(
                                              color: Colors.white),
                                        ),
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            'Logout',
                            style: GoogleFonts.k2d(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ]))
            ]),
          );
        });
  }
}

class UserInfo extends StatelessWidget {
  UserInfo({this.icon, this.title, this.content, this.reduceFont = false});
  final IconData icon;
  final String title;
  final String content;
  final bool reduceFont;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              title,
              style:
                  GoogleFonts.k2d(fontSize: 20, color: Colors.lightBlueAccent),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        Text(
          content,
          style: GoogleFonts.k2d(
              fontSize: reduceFont ? 18 : 20, color: Colors.black),
        ),
      ],
    );
  }
}

class EditProfileForm extends StatefulWidget {
  final String id;
  final Cuser user;
  EditProfileForm({this.id, this.user});

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _name = TextEditingController();
  final _town = TextEditingController();

  final _field = TextEditingController();
  final _fromSchool = TextEditingController();
  final _work = TextEditingController();
  final _bio = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  final _phone = TextEditingController();

  // List _file = [];

  // String _fileName;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          height: 500,
          padding: EdgeInsets.symmetric(horizontal: 15),
          color: Colors.grey[200],
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                decoration: InputDecoration(
                  labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                  labelText: 'Full name',
                ),
              ),
              TextFormField(
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                controller: _town,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Town'),
              ),

              TextFormField(
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'Phone'),
              ),
              // TextFormField(
              //   controller: _field,
              //   style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
              //   keyboardType: TextInputType.multiline,
              //   decoration: InputDecoration(
              //       labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
              //       labelText: 'Field ',
              //       helperText: 'In which field are you?'),
              // ),
              TextFormField(
                controller: _fromSchool,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                    labelText: 'School'),
              ),
              TextFormField(
                controller: _work,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                  labelText: 'Your current Job?',
                  // helperText: ''
                ),
              ),
              TextFormField(
                controller: _bio,
                style: kSellFormInputStyle.copyWith(color: Colors.deepOrange),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelStyle: klabelStyle.copyWith(color: Colors.blueGrey),
                  labelText: 'Let people know more about you',
                  // helperText: ''
                ),
              ),

              MaterialButton(
                onPressed: () {
                  String name = _name.text.isNotEmpty
                      ? _name.text.trim()
                      : widget.user.fullName;

                  String town = _town.text.isNotEmpty
                      ? _town.text.trim()
                      : widget.user.address;
                  String phone = _phone.text.isNotEmpty
                      ? _phone.text.trim()
                      : widget.user.phone;
                  String school = _fromSchool.text.isNotEmpty
                      ? _fromSchool.text.trim()
                      : widget.user.school;
                  String job = _work.text.isNotEmpty
                      ? _work.text.trim()
                      : widget.user.work;
                  String bio =
                      _bio.text.isNotEmpty ? _bio.text.trim() : widget.user.bio;
                  setState(() {
                    _loading = true;
                  });
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.user.id)
                      .update({
                    'Full name': name,
                    'Town': town,
                    'Phone Number': phone,
                    'School': school,
                    'Bio': bio,
                    'work': job,
                  }).whenComplete(() {
                    // mySnackbar(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Intermidiate()));
                    setState(() {
                      _loading = false;
                    });
                  }).catchError((error) {
                    print(error);
                  });
                },
                child: Text(
                  'Submit',
                  style: kButtonStyle,
                ),
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
