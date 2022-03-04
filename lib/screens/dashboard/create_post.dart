import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/screens/posts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;
import '../../constants.dart';

class CreatPost extends StatefulWidget {
  final DocumentReference reference;
  CreatPost({this.reference});

  @override
  _CreatPostState createState() => _CreatPostState();
}

class _CreatPostState extends State<CreatPost> {
  String _type;
  String _title;
  String _town;
  String _desc;

  int _price;
  String imgUrl;
  List<String> otherImagesUrl = [];
  final _formKey = GlobalKey<FormState>();
  String fileDownloadUrl;

  bool loading = false;

  File _imageFile;

  final _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    PickedFile selected = await _picker.getImage(
      source: source,
    );

    setState(() {
      _imageFile = File(selected.path);
    });
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
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

  _creatPost() async {
    if (_desc != null || _title != null || _imageFile != null) {
      setState(() {
        loading = true;
      });
      if (_imageFile != null) {
        Reference _reference = FirebaseStorage.instance
            .ref()
            .child('posts/${Path.basename(_imageFile.path)}');

        await _reference.putFile(_imageFile).whenComplete(() {
          _reference.getDownloadURL().then((url) {
            FirebaseFirestore.instance.collection('posts').add({
              'title': _title != null ? _title : '',
              'desc': _desc != null ? _desc : '',
              'image': url,
              'likes': 0,
              'LikeList': [],
              'comments': 0,
              'shares': 0,
              'saved': 0,
              'user': widget.reference,
              'time': DateTime.now()
            }).then((value) {
              Navigator.pop(context);
              setState(() {
                loading = false;
              });
            }).catchError((error) {
              print(error);
            });
          });
        }).catchError((error) {
          print(error);
        });
      } else {
        await FirebaseFirestore.instance.collection('posts').add({
          'title': _title != null ? _title : '',
          'desc': _desc != null ? _desc : '',
          'image': '',
          'likes': 0,
          'LikeList':[],
          'comments': 0,
          'shares': 0,
          'saved': 0,
          'user': widget.reference,
          'time': DateTime.now()
        }).then((value) {
          Navigator.pop(context);
          setState(() {
            loading = false;
          });
        }).catchError((error) {
          print(error);
        });
      }
    } else {
      setState(() {
        errorEmpty = true;
      });
    }
  }

  bool errorEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'Create a new post',
          style: GoogleFonts.k2d(fontSize: 20, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: loading,
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  TextFormField(
                    style: kSellFormInputStyle.copyWith(color: Colors.black87),
                    onChanged: (value) {
                      setState(() {
                        _title = value;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: klabelStyle,
                        icon: Icon(Icons.text_fields)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style: kSellFormInputStyle.copyWith(
                        fontSize: 16, color: Colors.black87),
                    decoration: InputDecoration(
                        labelText: 'Description...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.black12))),
                    onChanged: (val) {
                      setState(() {
                        _desc = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _imageFile != null
                      ? Container(
                          child: Column(
                            children: [
                              Container(
                                  constraints: BoxConstraints(maxHeight: 400),
                                  child: Image(
                                    image: FileImage(_imageFile),
                                    fit: BoxFit.cover,
                                  )),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => _cropImage(),
                                      child: Row(
                                        children: [
                                          Icon(
                                            LineIcons.crop,
                                            size: 30,
                                          ),
                                          Text(
                                            'Crop',
                                            style: GoogleFonts.k2d(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _imageFile = null;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            size: 30,
                                          ),
                                          Text(
                                            'Reset',
                                            style: GoogleFonts.k2d(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () => _pickImage(ImageSource.gallery),
                          child: Container(
                            color: Colors.grey,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Column(
                              children: [
                                Icon(
                                  LineIcons.image,
                                  color: Colors.white,
                                ),
                                Text('Add post image',
                                    style: GoogleFonts.k2d(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                        ),
                  MaterialButton(
                    onPressed: () => _creatPost(),
                    child: Text('Create',
                        style: GoogleFonts.k2d(color: Colors.white)),
                    color: Colors.blueGrey,
                  ),
                  errorEmpty
                      ? Container(
                          color: Colors.redAccent,
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            'All fields cannot be empty',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.k2d(
                                color: Colors.white, fontSize: 17),
                          ),
                        )
                      : Container(),
                  // PostsList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  const PostsList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final data = snapshot.data.docs;
        List<Widget> posts = data.map((e) {
          String title = e['title'];
          String desc = e['desc'];
          String img = e['image'];

          return Container(
            color: Colors.grey[200],
            child: ListTile(
              title: title == ''
                  ? Container()
                  : Text(
                      title,
                      style: GoogleFonts.k2d(
                        fontSize: 18,
                      ),
                    ),
              subtitle: desc == ''
                  ? Container()
                  : Text(
                      desc,
                      style:
                          GoogleFonts.k2d(fontSize: 16, color: Colors.black87),
                    ),
            ),
          );
        }).toList();

        return Expanded(
          child: Container(
            child: ListView(
              children: [
                Text(
                  'All posts',
                  style: klabelStyle,
                ),
                ...posts
              ],
            ),
          ),
        );
      },
    );
  }
}
