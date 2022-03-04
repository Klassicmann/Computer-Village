import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  // const Progress({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: Center(child: CircularProgressIndicator(backgroundColor: Colors.blueGrey,),),
    );
  }
}
