// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/models/user_model.dart';
import 'package:cv/servicesOffered/appdev.dart';
import 'package:cv/servicesOffered/business.dart';
import 'package:cv/servicesOffered/design.dart';
import 'package:cv/servicesOffered/internship.dart';
import 'package:cv/servicesOffered/ittraining.dart';
import 'package:cv/servicesOffered/job.dart';
import 'package:cv/servicesOffered/seo.dart';
import 'package:cv/servicesOffered/study.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:path/path.dart' as Path;

class Services extends StatelessWidget {
  final Cuser cuser;
  Services({this.cuser});
  // const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // File file = File(
    //     '/data/user/0/com.example.cv/cache/image_cropper_1627291348546.jpg');
    // Reference _reference = FirebaseStorage.instance
    //     .ref()
    //     .child('posts/${Path.basename(file.path)}');
    // _reference
    //     .putFile(file)
    //     .whenComplete(() => _reference.getDownloadURL().then((url) => {
    //           FirebaseFirestore.instance
    //               .collection('staticImages')
    //               .add({'title': 'cv', 'image': url})
    //         }))
    //     .catchError((error) {
    //   print(error);
    // });
    return SafeArea(
      child: Container(
          color: Colors.grey[200],
          child: Container(
            margin: EdgeInsets.only(top: 40, left: 30, right: 30),
            // width: 300,
            child: Center(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1),
                children: [
                  Service(
                    image: 'IMG_20210708_183715.jpg',
                    title: 'I.T Training',
                    id: 1,
                    widget: ITTraining(
                      userId: cuser.id,
                    ),
                  ),
                  Service(
                    image: 'IMG-20210708-WA0062.jpg',
                    title: 'Internship',
                    widget: Internship(userId: cuser.id,),
                  ),
                  Service(
                    image: 'computer-2982270_1280.jpg',
                    title: 'Web, Desktop and Mobile Developement',
                    id: 3,
                    widget: AppDevelopement(userid: cuser.id,),
                  ),
                  Service(
                    image: 'IMG_20210708_183715.jpg',
                    title: 'Job Opportunities',
                    id: 5,
                    widget: Job(userid : cuser.id),
                  ),
                  Service(
                    image: 'unnamed.png',
                    title: 'SEO',
                    widget: SEO(userId: cuser.id,),
                    id: 6,
                  ),
                  Service(
                    image: 'd1d1f27dfedd85ccc20e218375492df3.png',
                    title: 'Graphic Design',
                    id: 7,
                    widget: Design(id: cuser.id,),
                  ),
                  Service(
                    image: 'study.jpg',
                    title: 'Study in India',
                    id: 8,
                    widget: Study(userId: cuser.id,),
                  ),
                  Service(
                    image: 'laptop-is-my-office.jpg',
                    title: 'Business',
                    widget: Business(id:cuser.id),
                    id: 9,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class Service extends StatelessWidget {
  final String title;
  final String image;
  final int id;
  final Widget widget;
  const Service({this.title, this.image, this.id, this.widget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => widget)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.4),
          ),
          child: Stack(
            // alignment: Alignment.center,
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Image(
                  image: AssetImage('assets/images/$image'),
                  fit: BoxFit.cover,
                  height: 100,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Text(
                        title,
                        style: GoogleFonts.k2d(
                          color: Colors.grey[200],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
