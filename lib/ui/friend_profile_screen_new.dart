import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_up/ui/user.dart';
import 'package:flutter_me_up/resources/repository.dart';


class FriendProfileScreenNew extends StatefulWidget {

  final String name;
  FriendProfileScreenNew({this.name});

  @override
  _FriendProfileScreenNewState createState() =>
      _FriendProfileScreenNewState();
}

class _FriendProfileScreenNewState extends State<FriendProfileScreenNew> {
  String currentUserId, followingUserId;
  var _repository = Repository();
  User _user, currentuser;
  Future<List<DocumentSnapshot>> _future;
  bool isFollowing = false;
  bool followButtonClicked = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  String currentPage = "_InstaFriendProfileScreenNewState";


  fetchUidBySearchedName(String name) async {
    String uid = await _repository.fetchUidBySearchedName(name);
    setState(() {
      followingUserId = uid;
    });
    fetchUserDetailsById(uid);
    _future = _repository.retrieveUserPosts(uid);
  }

  fetchUserDetailsById(String userId) async {
    User user = await _repository.fetchUserDetailsById(userId);
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();

    fetchUidBySearchedName(widget.name);
    retrieveUserDetails();
  }

  Future<Null> retrieveUserDetails() async {
    _repository.getCurrentUser().then((user) {
      _repository.retrieveUserDetails(user).then((currentUser) {
        setState(() {
          currentuser = currentUser;
        });
      });
      _repository.checkIsFollowing(widget.name, user.uid).then((value) {
        setState(() {
          isFollowing = value;
        });
      });
      setState(() {
        currentUserId = user.uid;
      });
    });
  }

  followUser() {
    _repository.followUser(
        currentUserId: currentUserId, followingUserId: followingUserId);
    setState(() {
      isFollowing = true;
      followButtonClicked = true;
    });
  }

  unfollowUser() {
    _repository.unFollowUser(
        currentUserId: currentUserId, followingUserId: followingUserId);
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });
  }


  int getTotalScore(snapshot) {
    int totalScoreLikes = 0;
    int totalScoreComments = 0;

    snapshot.data.forEach((index) {

      totalScoreLikes = totalScoreLikes + index.data['likesCount'];
      totalScoreComments = totalScoreComments + index.data['commentsCount'];


    });

    return 866;
  }


  Widget buildButton({String text,

    Function function}) {
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return
      ButtonTheme(
          minWidth: width * 0.45,
          child:
          FlatButton(
              onPressed: function,
              color: Colors.blue,
              child: Center(
                child: Text(text, style: TextStyle(color: Colors.white)),
              )));
  }

  Widget buildProfileButton() {
    // already following user - should show unfollow button


    if (isFollowing) {
      return buildButton(
        text: "Unfollow",

        function: unfollowUser,
      );
    }

    // does not follow user - should show follow button
    if (!isFollowing) {
      return buildButton(
        text: "Follow",

        function: followUser,
      );
    }


    return buildButton(
        text: "loading...");
  }






  @override
  Widget build(BuildContext context) {

    double width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:




        Padding(

          padding: EdgeInsets.only(left: 8, right: 8),

        child:



            Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
        ButtonTheme(

          minWidth: (MediaQuery.of(context).size.width *0.7) - 8,
          child:
              isFollowing
           ? RaisedButton(


              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(30),
                  ),
              ),
              color: Colors.blue,

              onPressed: (){unfollowUser();},
              child: Text("Unfollow", style: TextStyle(color: Colors.white, fontSize: 15),))
        :
              RaisedButton(

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(30),
                      )),
                  color: Colors.blue,

                  onPressed: (){followUser();},
                  child: Text("Follow", style: TextStyle(color: Colors.white,  fontSize: 15),))

        ),

        Padding(
          padding: EdgeInsets.only(left: 6),
        child:

        ButtonTheme(

            minWidth: (MediaQuery.of(context).size.width *0.3) - 14,

            child:
           RaisedButton(


               shape: RoundedRectangleBorder(
                   side: BorderSide(color: Colors.blue),
                   borderRadius: BorderRadius.horizontal(
                     right: Radius.circular(30),
                   )),
                color: Colors.white,

                onPressed: (){ },
                child: Icon(Icons.send, color: Colors.blue,))


        ))

        ])),
        body:
        _user != null
            ?
        FutureBuilder(
            future: _future,
            builder:
            ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshotPosts) {

              return   CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(



                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(30),
                        )),
                    leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: (){Navigator.pop(context);}),
                    flexibleSpace: FlexibleSpaceBar(
                      background:
                      Padding(
                          padding: EdgeInsets.only(top: 56)
                          ,child:

                      Container(
                        decoration: new BoxDecoration(
                            color: Colors.blue,
                            borderRadius: new BorderRadius.only(
                                bottomRight: const Radius.circular(30.0),
                                bottomLeft: const Radius.circular(30.0))),
                        padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                        child:

                        Column(
                            children: [

                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 40.0,
                                      backgroundImage:
                                      new CachedNetworkImageProvider(
                                          _user.photoUrl),
                                    ),


                                    Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[


                                            Text(_user.displayName, style: TextStyle(color: Colors.white, fontSize: 18),),
                                            Padding(
                                                padding: EdgeInsets.only(top: 10),
                                                child:
                                                _user.bio != ""
                                                    ?
                                                Container(
                                                    width: MediaQuery.of(context).size.width * 0.56,
                                                    child:
                                                Text(_user.bio, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),))
                                                    : Container()),

                                          ]),
                                    )]),
                              Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[


                                      GestureDetector(
                                          child:
                                          detailsWidget(
                                             "20",
                                              'totalscore',
                                              Icons.score,
                                              20),

                                          onTap: () {

                                          }
                                      ),


                                      new Container(
                                        height: 30.0,
                                        width: 1.0,
                                        color: Colors.white30,
                                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      ),
                                      GestureDetector(
                                          child: detailsWidget(
                                              "56",
                                              'followers',
                                              Icons.people,
                                              20),
                                          onTap: () {


                                          }),

                                      new Container(
                                        height: 30.0,
                                        width: 1.0,
                                        color: Colors.white30,
                                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      ),

                                      GestureDetector(
                                          child: detailsWidget(
                                             "200",
                                              'following',
                                              Icons.people_outline,
                                              20),
                                          onTap: () {


                                          }),

                                    ],

                                  )),]),
                      )),
                    ),
                    snap: true,
                    floating: true,
                    expandedHeight: 230,
                    backgroundColor: Colors.blue,

                  ),



                ],
              );
            })
        ) : Container()
    );
  }

  Widget detailsWidget(String count, String label, IconData _icon, double size) {
    return

      Container(
          constraints: new BoxConstraints(
            minWidth: 100.0,
          ),
          alignment: Alignment.center,
          child:
          Row(
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        children: [
                          Icon(
                            _icon,
                            size: size,
                            color: Colors.white,

                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                              count,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400 ,
                                  fontSize: 16.0,
                                  color: Colors.white), textAlign: TextAlign.left)]),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child:
                      Text(label, style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w100)),
                    )
                  ],
                )]));
  }

}