import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishy/Admin/adminChat.dart';
import 'package:wishy/Admin/calander.dart';
import 'package:wishy/Admin/newCalendar.dart';
import '../global/global.dart';
import '../home/YourBooking.dart';
import '../splashScreen/splashScreen.dart';
import 'acceptedServices.dart';
import 'acceptRequestAdmin.dart';
import 'adminDrawer.dart';
import 'allUsers.dart';
import 'chatBoxAdmin.dart';
import 'myBooking.dart';

import 'dart:convert';

class FCMHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> subscribetoNotifications() async {
    String token = FirebaseMessaging.instance.getToken().toString();
    var message =
        FirebaseMessaging.instance.subscribeToTopic('admin_notifications');
  }
}

class adminHomePage extends StatefulWidget {
  const adminHomePage({Key? key}) : super(key: key);

  @override
  _adminHomePage createState() => _adminHomePage();
}

class _adminHomePage extends State<adminHomePage> {
  final FCMHandler _fcmHandler = FCMHandler();

  @override
  void initState() {
    super.initState();
    _fcmHandler.subscribetoNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('back button pressed');
        bool exit = await showDialog(
          useSafeArea: true,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit'),
              content: Text('Do you want to exit?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );

        if (exit == true) {
          // Save the data that the admin is still logged in using sharedpreferences
          var prefs = await SharedPreferences.getInstance();
          prefs.setBool(MySplashScreenState.ADMINLOGIN, true);
          // If the user clicks "Yes," exit the app
          SystemNavigator.pop();
        }

        return false; // Prevents the default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(),
          title: const Text(
            "Admin Washly",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
        ),
        drawer: adminDrawer(),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: GridView.count(
              padding: const EdgeInsets.all(15),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              primary: false,
              crossAxisCount: 2,
              children: [
                GestureDetector(
                  onTap: () => {allUsersAvailable()},
                  child: Card(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.account_circle_rounded,
                          color: Colors.white,
                          size: 33,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "All users",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {acceptBookingAdminFunction()},
                  child: Card(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.account_balance_sharp,
                          color: Colors.white,
                          size: 33,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "New Booking",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {AllBookingAvailable()},
                  child: Card(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.chat,
                          color: Colors.white,
                          size: 33,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "All Booking",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {AcceptedServices()},
                  child: Card(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 33,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Accepted Services",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {chatBoxAdminFunction()},
                  child: Card(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 33,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Chat",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {calanderPageFUncatoin()},
                  child: Card(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 33,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Calander",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  acceptBookingAdminFunction() {
    Navigator.of(context);
    Route route = MaterialPageRoute(builder: (c) => acceptBookingAdmin());
    Navigator.push(context, route);
  }

  allUsersAvailable() {
    Navigator.of(context);
    Route route = MaterialPageRoute(builder: (c) => allUsers());
    Navigator.push(context, route);
  }

  AllBookingAvailable() {
    Navigator.of(context);
    Route route = MaterialPageRoute(builder: (c) => AdminMyBooking());
    Navigator.push(context, route);
  }

  AcceptedServices() {
    Navigator.of(context);
    Route route = MaterialPageRoute(builder: (c) => allAcceptedServices());
    Navigator.push(context, route);
  }

  chatBoxAdminFunction() {
    Navigator.of(context);
    Route route = MaterialPageRoute(builder: (c) => adminChatDisplayUsers());
    Navigator.push(context, route);
  }

  calanderPageFUncatoin() {
    Navigator.of(context);
    Route route = MaterialPageRoute(builder: (C) => TableEventsExample());
    Navigator.push(context, route);
  }
//
// MyBookingbox(){
//   Navigator.of(context);
//   Route route = MaterialPageRoute(builder: (c) => MyBooking());
//   Navigator.push(context, route);
// }
}
