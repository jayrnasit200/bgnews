import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_app_api/views/homepage.dart';
import 'package:news_app_api/helper/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Indian English News",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: splashscreen(),
    );
  }
}

class splashscreen extends StatefulWidget {
  const splashscreen({key}) : super(key: key);

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Image.asset(
        "assets/logobg.png",
        height: 200,
        width: 200,
      )),
      // child: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         "Indian",
      //         style: TextStyle(
      //             color: Colors.black87,
      //             fontWeight: FontWeight.w600,
      //             decoration: TextDecoration.none),
      //       ),
      //       Text(
      //         "News",
      //         style: TextStyle(
      //             color: Colors.blue,
      //             fontWeight: FontWeight.w600,
      //             decoration: TextDecoration.none),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
