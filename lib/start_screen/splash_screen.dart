import 'dart:async';
import 'package:firebase_notes/screens/home_page.dart';
import 'package:firebase_notes/start_screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? uid;
  SharedPreferences? prefs;

  @override
  void initState() {
    checkUserExist();
    super.initState();
  }

  Widget nextPage = LoginPage();

  void checkUserExist() async {
    prefs = await SharedPreferences.getInstance();
    String uid = prefs!.getString('uid') ?? '';
    if (uid != null && uid != "") {
      nextPage = HomePage();
    }
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return nextPage;
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/notes_splash_logo.png",
              height: 100,
              width: 100,
              color: Colors.grey,
            ),
            Text(
              "Capture your thoughts, shape your ideas",
              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
