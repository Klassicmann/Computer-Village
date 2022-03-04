import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Who extends StatelessWidget {
  // const Who({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Who we are'),automaticallyImplyLeading: false,
      actions: [
        IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context))
      ],),
      body: Container(
        child: ListView(
          children: [
             Padding(
                  padding: EdgeInsets.all(11.0),
                  child: Text('Computer Village is a technology forum that was created on the 16 of June 2016 in the North West Region of Cameroon. The initial Purpose of Computer Village was to grow a strong technical team that could grow and be sustainable in line with the ever changing technological environment. Business activities kicked off for Computer village on the 4 th of July 2016 when it released a book title “Computer Guide”. This book was used in major secondary schools in the North West Region such as GBHS FUNDONG. In mid-2018, the computer developed a student Database management System using Microsoft Access + Visual Basic that is still in use till date. Other management systems were developed and are being used by businesses like Maria’s Health Care clinic, Golden Salon and Tom and Son’s Enterprise just to name a few. By 2019, 10 institutions were using systems developed by computer village. In the domain of web development, Computer Village has successfully developed fully functional websites, even for mission organization like Real Life Global Mission (www.realifeglobalmissions.org), www.s-shi.biz just to name a few. With time, The CEO of the computer Village introduced COMPUTER VILLAGE ACADEMY, which is currently offering training in the many ICT fields at Bonaberi-Entre-AncienneSONEL-RAIL. The aims of the Company have grown with time as will be discussed in the upcoming sections.', 
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.k2d(
                    fontSize: 17,
                    color: Colors.black87,
                    // fontWeight: FontWeight.w500
                  ),),
                ),
          ],
        ),
      ),
    );
  }
}
