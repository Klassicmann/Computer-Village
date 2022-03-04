import 'package:cv/screens/images.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FullImage extends StatelessWidget {
  final String image;
  final bool url;

  FullImage({this.image, this.url = false});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Image(
              image:url? NetworkImage(image) : AssetImage(image),
              height: double.infinity,
              width: double.infinity,
              // fit: BoxFit.cover,
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(FontAwesomeIcons.arrowCircleLeft)),
                    // Icon(FontAwesomeIcons.download),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
