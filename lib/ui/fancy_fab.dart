import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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

  File file;

  @override
  initState() {
   _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
   _iconColor = ColorTween(begin: Colors.white, end: Colors.red)
       .animate(CurvedAnimation(
     parent: _controller,
     curve: Interval(
       0.00,
       1.00,
       curve: Curves.linear,
     ),
   ));


   _buttonColor = ColorTween(begin: Colors.red, end: Colors.white)

       .animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));

    super.initState();
  }

  goToVideoGallery() {

    _controller.reverse();

  }

  goToVideoCamera() {

    _controller.reverse();

  }

  goToCamera() async {

    _controller.reverse();
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

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0)), side: BorderSide(color: Colors.red, width: 4.0)),

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
            child: Icon(Icons.score, color: Colors.red),
            onPressed: () {
              goToCamera();
            },
          ),
        ),
      ),
      Container(
        height: 70.0,
        width: 56.0,
        alignment: FractionalOffset.topCenter,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1.0 - 2 / 2 / 2.0, curve: Curves.easeOut),
          ),
          child: FloatingActionButton(
            heroTag: "gallery",
            backgroundColor: backgroundColor,
            mini: true,
            child: Icon(Icons.healing, color: Colors.red),
            onPressed: () {
              goToGallery();
            },
          ),
        ),
      ),


    ]);
  }
}
