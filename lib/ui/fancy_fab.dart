import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_me_up/resources/repository.dart';

// https://stackoverflow.com/questions/46480221/flutter-floating-action-button-with-speed-dail
class FancyFab extends StatefulWidget {
  final Function() fetch;

  FancyFab({this.fetch});

  @override
  State createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isVideo = false;

  AnimationController _controller;
  Animation<Color> _buttonColor;
  Animation<Color> _iconColor;
  FirebaseUser currentUser;
  var _locationController;
  double longitude;
  double latitude;

  File file;
  var _repository = Repository();

  @override
  initState() {
   _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
   _iconColor = ColorTween(begin: Colors.white, end: Colors.blue)
       .animate(CurvedAnimation(
     parent: _controller,
     curve: Interval(
       0.00,
       1.00,
       curve: Curves.linear,
     ),
   ));

   initPlatformState();

   _buttonColor = ColorTween(begin: Colors.blue, end: Colors.white)

       .animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));


   _repository.getCurrentUser().then((user) {
     setState(() {
       currentUser = user;
     });
   });

   _locationController = TextEditingController();

    super.initState();
  }

 updateCurrentPosition(){
   _repository
       .updateDetails(
       currentUser.uid,
      longitude,
   latitude);
 }

  initPlatformState() async {
    Placemark first = await locateUser();
    setState(() {
      longitude = first.position.longitude;
      latitude = first.position.latitude;
    });

    print("Koordinaten: $longitude");


  }

  locateUser() async {
    Position currentLocation;


    final Geolocator geolocator = Geolocator()
      ..forceAndroidLocationManager = true;



    // Platform messages may fail, so we use a try/catch PlatformException.

    currentLocation = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);



    print(
        'LATITUDE : ${currentLocation.latitude} && LONGITUDE : ${currentLocation.longitude}');

    // From coordinates


    print('1');

    List<Placemark> addresses = await Geolocator().placemarkFromCoordinates(currentLocation.latitude, currentLocation.longitude);


    print(addresses.first);

    var firstCoordinates = addresses.first;

    return firstCoordinates;
  }

  goToCamera() async {

    updateCurrentPosition();

    _controller.reverse();
  }

  @override
  void dispose() {
    super.dispose();
    _locationController?.dispose();
  }


  goToGallery() async {

    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[_buildChild(), _buildFab()]);
  }

  Widget _buildFab() {
    return FloatingActionButton(

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0)), side: BorderSide(color: Colors.blue, width: 4.0)),

      backgroundColor: _buttonColor.value,
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      tooltip: 'Increment',
      child:


      Icon(
        _controller.isDismissed
        ? Icons.add : Icons.close,
        color: _iconColor.value,
      ),


      elevation: 0.0,
    );
  }

  Widget _buildChild() {
    Color backgroundColor = Theme.of(context).cardColor;
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Container(
        height: 70.0,
        width: 56.0,
        alignment: FractionalOffset.topCenter,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1.0 - 1 / 2 / 2.0, curve: Curves.easeOut),
          ),
          child: FloatingActionButton(
            heroTag: "camera",
            backgroundColor: backgroundColor,
            mini: true,
            child: Icon(Icons.my_location, color: Colors.blue),
            onPressed: () {
              goToCamera();
            },
          ),
        ),
      ),

    ]);
  }


}
