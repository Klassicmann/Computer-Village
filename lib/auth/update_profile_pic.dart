import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/screens/instermidiate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;

class AddProfileImage extends StatefulWidget {
  final String id;
  AddProfileImage({this.id});
  @override
  _AddProfileImageState createState() => _AddProfileImageState();
}

class _AddProfileImageState extends State<AddProfileImage>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
    _animation = Tween<double>(begin: 50, end: 300).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  bool loading = false;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Stack(
            children: [
              Image(
                image: AssetImage('assets/images/flash.png'),
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    color: Colors.blue.withOpacity(0.8),
                    height: _animation.value,
                    width: double.infinity,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.black87,
                    height: _animation.value,
                    width: double.infinity,
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                              child: Text(
                            'Your account was created successfully!',
                            style: GoogleFonts.k2d(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          )),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            'Add profile image',
                            style: GoogleFonts.k2d(
                              color: Colors.lightBlue,
                              fontSize: 16,
                            ),
                          )),
                        ),
                        Center(
                          child: _imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                      height: 180,
                                      width: 152,
                                      child:
                                          Image(image: FileImage(_imageFile))),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    await _pickImage(ImageSource.gallery);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        if (_imageFile != null)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            child: MaterialButton(
                              onPressed: () async {
                                User _user = FirebaseAuth.instance.currentUser;

                                setState(() {
                                  loading = true;
                                });
                                Reference reference = FirebaseStorage.instance
                                    .ref('profile')
                                    .child(
                                        'profileImages/${Path.basename(_imageFile.path)}');
                                await reference
                                    .putFile(_imageFile)
                                    .whenComplete(() {
                                  reference.getDownloadURL().then((url) {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.id)
                                        .update({'PhotoUrl': url});
                                  }).whenComplete(() {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Intermidiate(
                                                  id: 3,
                                                )));
                                    _user.sendEmailVerification();
                                    setState(() {
                                      loading = false;
                                    });
                                  });
                                }).catchError((error) {
                                  print(error);
                                });
                              },
                              child: Text(
                                'Add profile image',
                                style: GoogleFonts.k2d(
                                    color: Colors.white, fontSize: 17),
                              ),
                              color: Colors.lightBlue,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
