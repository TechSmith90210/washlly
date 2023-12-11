import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wishy/DialogBox/errorDialog.dart';

import '../global/global.dart';
import '../widgets/loadingWidget.dart';
import 'homePage.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

String? locationAssigned;

class MapSampleState extends State<MapSample> {
  Position? position;
  List<Placemark>? placemarks;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  late LatLng latLatPostion;
  var user = sharedPreferences?.getString("uid");
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.730610, -73.935242),
    zoom: 14.4744,
  );
  TextEditingController locationController = TextEditingController();

  // Add default values for latitude and longitude
  void locatePostion(
      {double? defaultLatitude, double? defaultLongitude}) async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    // Use default values if parameters are not provided
    double latitude = defaultLatitude ?? 40.730610;
    double longitude = defaultLongitude ?? -73.935242;

    Position positionNew = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    CurrentPosition = positionNew;

    position = positionNew;
    placemarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark Pmark = placemarks![0];
    String newCurrentAddress =
        '${Pmark.subThoroughfare} ${Pmark.thoroughfare}, ${Pmark.subLocality} ${Pmark.locality}, ${Pmark.subAdministrativeArea}, ${Pmark.administrativeArea} ${Pmark.postalCode}, ${Pmark.country}';

    locationAssigned = newCurrentAddress.toString();
    setState(() {
      locationAssigned = newCurrentAddress.toString();
    });

    latLatPostion = LatLng(latitude, longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLatPostion, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  late Position CurrentPosition;
  late var geoLocator = Geolocator();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                locatePostion(
                    defaultLatitude: 37.7749, defaultLongitude: -122.4194);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Enter your Location",
                suffixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.all(5),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.white)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.white)),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 90,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                fixedSize: const Size(170, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                "Next",
                style: TextStyle(
                  fontSize: 21,
                ),
              ),
              onPressed: () {
                UploadSelectedDate();
              },
            ),
          ),
        ],
      ),
    );
  }

  UploadSelectedDate() async {
    showDialog(
      context: context,
      builder: (c) {
        return const Error_Alert_Dialog(
            message: "Thank you for booking with us.");
      },
    ).then((value) async {
      await thisIsToGetAll();
    });
  }

  Future thisIsToGetAll() async {
    await FirebaseFirestore.instance.collection("services").doc(user).update({
      "Address": locationAssigned,
      "lat": position!.latitude,
      "long": position!.longitude,
    });

    // Navigate to Home_page using MaterialPageRoute
    Route route = MaterialPageRoute(builder: (c) => Home_page());
    Navigator.push(context, route);
    print('Navigated using material page route');

    // Set a delay of 4 seconds
    await Future.delayed(Duration(seconds: 4));

    // Check if the user has navigated to the Home_page
    if (!Navigator.canPop(context)) {
      // If not, navigate to the Home_page using Get.to method
      print('navigated using Get');
      Get.to(Home_page());
    }
  }
}
