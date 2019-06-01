import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_up/main.dart';
import 'package:flutter_me_up/resources/repository.dart';



class Home extends StatefulWidget {
  // InstaProfileScreen();

  @override
  HomeState createState() => HomeState();
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


  @override
  void initState() {
    super.initState();
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

 /* FutureBuilder<http.Response> fetchPost(){
    return http.get('https://jsonplaceholder.typicode.com/posts/1');
  }*/






  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
        backgroundColor: Colors.red,
        body: Stack(
          children: <Widget>[
            menu(context),


            buildProfile(context)



          ],
        )



    );
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

                              CustomScrollView(
                                slivers: <Widget>[

                                  SliverAppBar(


                                    floating: true,
                                    pinned: false,
                                    snap: true,
                                    expandedHeight: 56,
                                    backgroundColor: Colors.red,
                                    title: Text("Home", style: TextStyle(color: Colors.white),),
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
                                    ,
                                  ),




                                ],
                              ),

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
              backgroundColor: Colors.red ,
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
                color: Colors.red,
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
                                      'Menü_Punkt_1   ',
                                      style: TextStyle(
                                          color: Colors
                                              .white, fontSize: 20)),
                                  Icon(
                                    Icons.edit,
                                    color:
                                    Colors.white,
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {

                                  _controller.reverse().then((_){

                                  });
                                  isCollapsed = !isCollapsed;
                                });


                              },
                            ),

                            SizedBox(height: 20),
                            GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[

                                  Text(
                                      'Menü_Punkt_2   ',
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


