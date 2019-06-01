import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_up/main.dart';
import 'package:flutter_me_up/resources/repository.dart';
import 'package:flutter_me_up/ui/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Home extends StatefulWidget {
  // InstaProfileScreen();

  @override
  HomeState createState() => HomeState();
  Future<List<DocumentSnapshot>> _future;

}

class HomeState extends State<Home> with SingleTickerProviderStateMixin{
  bool isCollapsed = true;
  double screenHeight, screenWidth;
  final Duration duration = const Duration(milliseconds: 300);

  String currentPage = "_InstaProfileScreenNewState";
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;

  Animation<Offset> _slideAnimation;

  var _repository = Repository();
  User _user;

  Completer<GoogleMapController> _mapController = Completer();


  static  LatLng _center =  LatLng(49.732570, 9.990263);
  static  LatLng _center2 =  LatLng(49.792570, 9.990263);
  static  LatLng _center3 =  LatLng(49.800000, 9.990263);
  static  LatLng _center4 =  LatLng(49.732570, 10.00000);


  void _onMapCreated(GoogleMapController controller) {

    _mapController.complete(controller);

  }

  void retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      _user = user;

    });
    widget._future = _repository.retrieveUserPosts(_user.uid);
  }

  @override
  void initState() {

    _onAddMarkerButtonPressed(_center);
    _onAddMarkerButtonPressed(_center2);
    _onAddMarkerButtonPressed(_center3);
    _onAddMarkerButtonPressed(_center4);

    super.initState();
    retrieveUserDetails();

    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.7).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);

    _slideAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(_controller);
  }

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  @override
  void didUpdateWidget(Home oldWidget) {
    if (oldWidget._future != widget._future) {
      retrieveUserDetails();
    }
    super.didUpdateWidget(oldWidget);

  }


  /* FutureBuilder<http.Response> fetchPost(){
    return http.get('https://jsonplaceholder.typicode.com/posts/1');
  }*/

  final Set<Marker> _markers = {};


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(
          title:

          GestureDetector(

              onTap: (){

              },
              child:
              Row(
                  children: [


                    Text("Flutter Me Up",  style: const TextStyle(
                        fontFamily: "Bangers", color: Colors.white, fontSize: 30.0),),
                    SizedBox(
                      width: 20,
                    ),
                    Image.asset("assets/flutter_logo.png", height: 40, width: 40,),
                  ])),
          leading:

          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            onPressed: ()  {

              setState(() {
                if(isCollapsed)
                  _controller.forward();
                else
                  _controller.reverse();
                isCollapsed = !isCollapsed;
              });
            },
          )
      ),
        backgroundColor: Colors.blue,
        body: Stack(
          children: <Widget>[
            menu(context),

         buildProfile(context)



          ],
        )



    );
  }



  void _onAddMarkerButtonPressed(LatLng pos) {

    LatLng _lastMapPosition = pos;

    setState(() {
      _markers.add(


          Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: "Flutter Coder",
          snippet: 'Score 56',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Widget buildProfile(context){

    return AnimatedPositioned(
        duration: duration,
        top: 0,
        left: isCollapsed ? 0 : -0.5 * screenWidth,
        bottom: 0,
        right: isCollapsed ? 0 : 0.5 * screenWidth,
        child:
        ScaleTransition(
          scale: _scaleAnimation,
          child:

          Material(

              borderRadius: BorderRadius.all(Radius.circular( isCollapsed ? 0 : 20)),
              elevation: 4,
              child:

                     Stack(
                        children: [

                          Container(child:
                          GoogleMap(

                              markers: _markers,

                              onMapCreated: _onMapCreated,

                              initialCameraPosition: CameraPosition(

                                target: _center,

                                zoom: 11.0,))),

                          isCollapsed


                              ? Container()

                              : Positioned.fill(
                            child: GestureDetector(
                              child:
                              Container(
                                color: Colors.transparent,
                              ),
                              onTap: (){

                                isCollapsed
                                // ignore: unnecessary_statements
                                    ? null
                                    : setState(() {
                                  _controller.reverse();
                                  isCollapsed = !isCollapsed;
                                });

                              },
                            ),


                          )


                        ]


                    ))

          ),



        );}


  Widget menu(context){
    return SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _menuScaleAnimation,
          child:

          Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: Container(),
              backgroundColor: Colors.blue ,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.close, color: Colors.white,),
                    onPressed: (){

                      setState(() {
                        _controller.reverse();
                        isCollapsed = !isCollapsed;
                      });
                    })
              ],
            ),
            body:
            Container(
                color: Colors.blue,
                child:
                Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Align(


                        alignment: Alignment.centerRight,
                        child: Column(

                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[


                            GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[

                                  Text(
                                      'Logout   ',
                                      style: TextStyle(
                                          color: Colors
                                              .white, fontSize: 20)),
                                  Icon(
                                    Icons.power_settings_new,
                                    color:
                                    Colors.white,
                                  ),
                                ],
                              ),
                              onTap: () {

                                setState(() {
                                  _controller.reverse().then((_) async {
                                    await _repository.signOut().then((v) {
                                      Navigator.pushReplacement(context,
                                          CupertinoPageRoute(
                                              builder: (context) {
                                                return MyApp();
                                              }));
                                    });
                                  });
                                  isCollapsed = !isCollapsed;
                                });

                              },
                            ),

                          ],
                        )))),
          ),


        ));
  }



}


