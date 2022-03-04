import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/screens/audio.dart';
import 'package:cv/screens/compressed.dart';
import 'package:cv/screens/documents.dart';
import 'package:cv/screens/images.dart';
import 'package:cv/screens/videos.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class Galery extends StatelessWidget {
  Widget build(BuildContext context) {
    int imagesCount = 0;

    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(20),
      child: ListView(
        children: [
          Text(
            'File Manager',
            style: GoogleFonts.k2d(fontSize: 23, color: Colors.blueGrey),
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('image files')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blueGrey,
                    ),
                  );
                }
                final images = snapshot.data.docs;
                images.forEach((element) {
                  List itemImages = element['images'];

                  imagesCount += itemImages.length;
                });
                return Folders(
                  icon: FontAwesomeIcons.images,
                  text: 'Images',
                  count: imagesCount,
                  widget: Images(),
                  
                );
              }),
          Folders(
            icon: FontAwesomeIcons.viadeoSquare,
            text: 'Videos',
            count: 0,
            widget: Videos(),
          ),
          Folders(
            icon: FontAwesomeIcons.music,
            text: 'Audio',
            count: 0,
            widget: Audio(),
          ),
          Folders(
            icon: FontAwesomeIcons.fileAlt,
            text: 'Documents',
            count: 0,
            widget: Documents(),
          ),
          Folders(
            icon: FontAwesomeIcons.compress,
            text: 'Compressed',
            count: 0,
            widget: Compressed(),
          ),
        ],
      ),
    );
  }
}

class Folders extends StatelessWidget {
  Folders({this.icon, this.text, this.count, this.tap, this.widget});
  final IconData icon;
  final String text;
  final int count;
  final Function tap;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => widget)),
      child: ListTile(
        leading: Icon(
          icon,
          size: 30,
          color: Colors.blueGrey,
        ),
        title: Text(
          text,
          style: GoogleFonts.k2d(fontSize: 23),
        ),
        trailing:
            Text(count.toString(), style: GoogleFonts.adamina(fontSize: 18)),
      ),
    );
  }
}
