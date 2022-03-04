import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv/screens/full_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class Images extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List list = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Images'),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('image files').orderBy('time', descending: true)
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
              List<Grids> _list = images.map((e) {
                List items = e['images'];
                List allItems =
                    items.map((item) => GestureDetector(
                      onTap:() => Navigator.push(context, MaterialPageRoute(builder: (context) => FullImage(image: item, url:  true,))),
                      child: Image(image: NetworkImage(item)))).toList();
                return Grids(
                  lenght: items.length.toDouble(),
                  list: allItems,
                  title: e['title'] != ''? e['title']: '',
                );
              }).toList();
              return ListView(
                shrinkWrap: true,
                children: [
                  ..._list,
                  Divider(
                    thickness: 1,
                  )
                ],
              );
            }),
      ),
    );
  }
}

class Grids extends StatelessWidget {
  const Grids({
    Key key,
    @required this.lenght,
    @required List<Widget> list,
    this.title,
    this.date
  })  : _list = list,
        super(key: key);

  final double lenght;
  final List<Widget> _list;
  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300, minHeight: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '02/12/2021',
                  style: GoogleFonts.k2d(),
                ),
                Icon(LineIcons.download)
              ],
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              title,
              style: GoogleFonts.k2d(fontSize: 19),
            ),
          ),
          Container(
            height: lenght * 100,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1,
              ),
              children: _list,
            ),
          ),
        ],
      ),
    );
  }
}
