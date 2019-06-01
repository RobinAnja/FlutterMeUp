import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_up/resources/repository.dart';
import 'package:flutter_me_up/ui/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListScreen extends StatefulWidget {
  @override
  ListScreenState createState() => ListScreenState();
  Future<List<DocumentSnapshot>> _future;

}

class ListScreenState extends State<ListScreen> {
  var _repository = Repository();

  User _user;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();

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