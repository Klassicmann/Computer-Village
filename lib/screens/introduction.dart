import 'package:cv/auth/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Login()),
    );
  }

  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/images/IMG-20210706-WA0019.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = double.infinity]) {
    return Image.asset('assets/images/$assetName', width: width,fit: BoxFit.cover,);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
        fontSize: 19.0,
        color: Color(0xFF002140),
        fontWeight: FontWeight.w600,
        );

    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(
            fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.blue),
        bodyTextStyle: bodyStyle,
        descriptionPadding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 16.0),
        pageColor: Colors.white,
        imagePadding: EdgeInsets.only(top: 20),
        contentMargin: EdgeInsets.only(top: 50, left: 20, right: 20));

    return IntroductionScreen(
      key: introKey,

      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(top: 16, right: 16),
          // child: _buildImage('Best-android-smartphones-in-nigeria.jpeg', 300),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
          child: Text(
            'Let\s go right away!',
            style: GoogleFonts.k2d(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Welcome to Computer Village",
          body:
              "We have a mordern tranning center to teach students in different I.T departments.",
          image: _buildImage('logo.jpg'),
          decoration: pageDecoration,
        ),
        
        PageViewModel(
          title: "Websites and Application Developement",
          body:
              "We build websites, mobile and desktop applications with advanced functionalities and user experience ",
          image: _buildImage('unnamed.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Internship",
          body:
              "Computer Village offers academic and proffessional internship to many students in different fields of study ",
          image: _buildImage('IMG-20210706-WA0019.jpg'),
          decoration: pageDecoration,
        ),
        // PageViewModel(
        //   title: "Internship",
        //   body:
        //       "Offering internship to students in all fields of studies",
        //   image: _buildImage('IMG-20210708-WA0089.jpg'),
        //   decoration: pageDecoration,
        // ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: Text('Skip'),
      next: Icon(Icons.arrow_forward),
      done: Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? EdgeInsets.all(12.0)
          : EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFABABDD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only( topLeft:Radius.circular(0.0)),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text("This is the screen after Introduction")),
    );
  }
}
