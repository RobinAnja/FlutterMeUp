import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:CustomScrollView(
        slivers: <Widget>[

          SliverAppBar(

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                )),

            flexibleSpace: FlexibleSpaceBar(
              background:
              Padding(
                  padding: EdgeInsets.only(top: 56)
                  ,child:

              Container(
                  decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: new BorderRadius.only(
                          bottomRight: const Radius.circular(30.0),
                          bottomLeft: const Radius.circular(30.0))),
                  padding: const EdgeInsets.all(20),
                  child: Container()



              )),
            ),
            floating: true,
            pinned: false,
            snap: true,
            expandedHeight: 200,
            backgroundColor: Colors.red,
            title: Text("Profil"),

          ),




        ],
      ),
    );
  }
}