import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishy/Admin/adminHomePage.dart';
import 'package:wishy/global/global.dart';
import 'package:wishy/loginPage.dart';
import 'package:wishy/wishy_home.dart';

import '../home/homePage.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  MySplashScreenState createState() => MySplashScreenState();
}

class MySplashScreenState extends State<MySplashScreen> {
  static const String ADMINLOGIN = "AdminLogin";
  static const String USERLOGIN = "UserLogin";
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 0), () => displaySplash());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void displaySplash() async {
    var sharedpref = await SharedPreferences.getInstance();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) async {
        var adminLoggedIn = sharedpref.getBool(ADMINLOGIN) ?? false;
        var userLoggedIn = sharedpref.getBool(USERLOGIN) ?? false;

        print("Admin Logged In: $adminLoggedIn");
        print("User Logged In: $userLoggedIn");

        // navigation logic
        if (adminLoggedIn! && !userLoggedIn!) {
          print("Navigate to AdminHomePage");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => adminHomePage()));
        } else if (!adminLoggedIn && userLoggedIn!) {
          print("Navigate to Home_page");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home_page()));
        } else {
          print("Navigate to login_page");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => login_page()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/img/car-wash.jpg",
                width: 200.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Welcome To Washly",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//if (adminloggedin != null && userloggedin != null) {
//   if (adminloggedin && !userloggedin) {
//     // send to admin homepage
//   } else if (!adminloggedin && userloggedin) {
//     // send to user homepage
//   } else {
//     // send to login page
//   }
// } else {
//   // send to login page
// }
