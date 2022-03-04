import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/constants.dart';
import 'package:cv/widgets/login_form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;

class AddFiles extends StatefulWidget {
  // const AddFiles({ Key? key }) : super(key: key);

  @override
  _AddFilesState createState() => _AddFilesState();
}

class _AddFilesState extends State<AddFiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFF002140),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Add Files'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Divider(),
              FilType(text: 'Image', id: 1,),
              Divider(),
              FilType( text: 'Video', id: 2,),
              Divider(),
              FilType(text: 'Audio', id: 3,),
              Divider(),
              FilType(text: 'Document', id: 4,),
            ],
          ),
        ),
      ),
    );
  }
}

class FilType extends StatelessWidget {
  final String text;
  final int id;

  FilType({this.text, this.id});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.black54,
          context: context,
          builder: (context) {
            return ShowBottomSheet(
              id: id,
            );
          }),
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: klabelStyle.copyWith(color: Colors.black),
          )),
    );
  }
}

class ShowBottomSheet extends StatefulWidget {
  final int id;

  ShowBottomSheet({Key key, this.id});

  @override
  _ShowBottomSheetState createState() => _ShowBottomSheetState();
}

class _ShowBottomSheetState extends State<ShowBottomSheet> {
  final _titleController = TextEditingController();

  List _imagesList = [];
  ImagePicker _picker = ImagePicker();

  List<String> _imageUrls = [];
  bool loading = false;

  Future<void> _pickImage() async {
    List<PickedFile> _selected = await _picker.getMultiImage(imageQuality: 75);

    for (var i in _selected) {
      setState(() {
        _imagesList.add(File(i.path));
      });
      print(_imagesList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return ModalProgressHUD(
            inAsyncCall: loading,
            child: Container(
              height: MediaQuery.of(context).size.width / 1,
              color: Colors.black87,
              child: widget.id == 1
                  ? ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Upload Image(s)',
                            style:
                                klabelStyle.copyWith(color: Colors.lightBlue),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: LoginField(
                              controller: _titleController,
                              label: 'Title',
                              prefixicon: Icons.text_fields),
                        ),
                        _imagesList == []
                            ? Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () => _pickImage(),
                                    child: CircleAvatar(
                                      child: Icon(Icons.add_a_photo),
                                      radius: 50,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        _imagesList != []
                            ? Container(
                                height: 160,
                                width: 100,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      GestureDetector(
                                        onTap: () => _pickImage(),
                                        child: CircleAvatar(
                                          child: Icon(Icons.add_a_photo),
                                          radius: 40,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      ..._imagesList
                                          .map((e) => Stack(
                                                children: [
                                                  Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2,
                                                              vertical: 10),
                                                      child: Image(
                                                        image: FileImage(e),
                                                        width: 100,
                                                        height: double.infinity,
                                                        fit: BoxFit.cover,
                                                      )),
                                                  IconButton(
                                                      icon: Icon(Icons.cancel),
                                                      onPressed: () {
                                                        //  _imagesList.removeWhere((element) => )
                                                      })
                                                ],
                                              ))
                                          .toList()
                                          .reversed,
                                    ]),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: MaterialButton(
                            onPressed: () async {
                              if (_imagesList != null) {
                                setState(() {
                                  loading = true;
                                });
                                for (File i in _imagesList) {
                                  Reference img = FirebaseStorage.instance
                                      .ref()
                                      .child(
                                          'otherImages/${Path.basename(i.path)})');
                                  UploadTask task = img.putFile(i);

                                  await task.whenComplete(() {
                                    img.getDownloadURL().then((url) {
                                      setState(() {
                                        _imageUrls.add(url);
                                      });
                                    });
                                  }).catchError((error) {
                                    print(error);
                                  });
                                }
                                FirebaseFirestore.instance
                                    .collection('image files')
                                    .add({
                                  'title': _titleController.text.trim(),
                                  'images': _imageUrls,
                                  'time': DateTime.now(),
                                }).whenComplete(() {
                                  SnackBar(
                                      content:
                                          Text('Images uplaoded successfully'));
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.pop(context);
                                }).catchError((error) {
                                  print(error);
                                });
                              }
                            },
                            child: Text(
                              'Upload',
                              style: klabelStyle.copyWith(color: Colors.white),
                            ),
                            color: Colors.lightBlue,
                          ),
                        )
                      ],
                    )
                  : Container(),
            ),
          );
        });
  }
}
