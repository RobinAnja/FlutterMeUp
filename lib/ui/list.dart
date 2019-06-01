import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_up/resources/repository.dart';
import 'package:flutter_me_up/ui/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreenNew extends StatefulWidget {
  // InstaProfileScreen();
  Future<List<DocumentSnapshot>> _future;

  @override
  _ProfileScreenNewState createState() => _ProfileScreenNewState();
}

class _ProfileScreenNewState extends State<ProfileScreenNew>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ProfileScreenNew>,

        FlareController {
  var _repository = Repository();
  bool isCollapsed = true;
  double screenHeight, screenWidth;
  final Duration duration = const Duration(milliseconds: 300);

  User _user;
  String currentPage = "_InstaProfileScreenNewState";


  ActorAnimation _loadingAnimation;
  ActorAnimation _successAnimation;
  ActorAnimation _pullAnimation;
  ActorAnimation _cometAnimation;

  RefreshIndicatorMode _refreshState;
  double _pulledExtent;
  double _refreshTriggerPullDistance;
  double _refreshIndicatorExtent;
  double _successTime = 0.0;
  double _loadingTime = 0.0;
  double _cometTime = 0.0;

  void initialize(FlutterActorArtboard actor) {
    _pullAnimation = actor.getAnimation("pull");
    _successAnimation = actor.getAnimation("success");
    _loadingAnimation = actor.getAnimation("loading");
    _cometAnimation = actor.getAnimation("idle comet");
  }

  void setViewTransform(Mat2D viewTransform) {}

  bool advance(FlutterActorArtboard artboard, double elapsed) {
    double animationPosition = _pulledExtent / _refreshTriggerPullDistance;
    animationPosition *= animationPosition;
    _cometTime += elapsed;
    _cometAnimation.apply(_cometTime % _cometAnimation.duration, artboard, 1.0);
    _pullAnimation.apply(
        _pullAnimation.duration * animationPosition, artboard, 1.0);
    if (_refreshState == RefreshIndicatorMode.refresh ||
        _refreshState == RefreshIndicatorMode.armed) {
      _successTime += elapsed;
      if (_successTime >= _successAnimation.duration) {
        _loadingTime += elapsed;
      }
    } else {
      _successTime = _loadingTime = 0.0;
    }
    if (_successTime >= _successAnimation.duration) {
      _loadingAnimation.apply(
          _loadingTime % _loadingAnimation.duration, artboard, 1.0);
    } else if (_successTime > 0.0) {
      _successAnimation.apply(_successTime, artboard, 1.0);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
  }
  @override
  void dispose() {
    super.dispose();
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
  void didUpdateWidget(ProfileScreenNew oldWidget) {
    if (oldWidget._future != widget._future) {
      retrieveUserDetails();
      super.didUpdateWidget(oldWidget);
    }
  }

  Widget buildRefreshWidget(
      BuildContext context,
      RefreshIndicatorMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent) {
    _refreshState = refreshState;
    _pulledExtent = pulledExtent;
    _refreshTriggerPullDistance = refreshTriggerPullDistance;
    _refreshIndicatorExtent = refreshIndicatorExtent;

    return FlareActor("flare_animations/Space Demo.flr",
        alignment: Alignment.center,
        animation: "idle",
        fit: BoxFit.cover,
        controller: this);
  }



  Future<Null> _refresh() async {
    retrieveUserDetails();

    setState(() {});

    return;
  }

  int getTotalScore(snapshot) {
    int totalScoreLikes = 0;
    int totalScoreComments = 0;

    if (mounted) {
      if (snapshot.hasData) {
        snapshot.data.forEach((index) {
          totalScoreLikes = totalScoreLikes + index.data['likesCount'];
          totalScoreComments = totalScoreComments + index.data['commentsCount'];
        });
      }
    }

    return 322;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    super.build(context); // reloads state when opened again

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          platform: TargetPlatform.iOS,
        ),
        home: Scaffold(
            backgroundColor: Colors.white,
            body:  buildProfile(context)
            ));
  }

  Widget buildProfile(context) {
    return _user != null
                  ? FutureBuilder(
                  future: widget._future,
                  builder: ((context,
                      AsyncSnapshot<List<DocumentSnapshot>> snapshotPosts) {
                    return
                      CustomScrollView(
                        slivers: <Widget>[
                          CupertinoSliverRefreshControl(
                            refreshTriggerPullDistance: 190.0,
                            refreshIndicatorExtent: 190.0,
                            builder: buildRefreshWidget,
                            onRefresh: () {
                              return Future<void>.delayed(
                                  const Duration(seconds: 3))
                                ..then<void>((_) {
                                  if (mounted) {
                                    retrieveUserDetails();
                                  }
                                });
                            },
                          ),
                          SliverAppBar(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(30),
                                )),
                            flexibleSpace: FlexibleSpaceBar(

                              background: Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Container(
                                    decoration: new BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: new BorderRadius.only(
                                            bottomRight:
                                            const Radius.circular(30.0),
                                            bottomLeft:
                                            const Radius.circular(
                                                30.0))),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(children: [
                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 40.0,
                                              backgroundImage:
                                              new CachedNetworkImageProvider(
                                                  _user.photoUrl),
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsets.only(left: 30),
                                              child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(
                                                      _user.displayName,
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 18),
                                                    ),
                                                    Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            top: 10,
                                                            right: 10),
                                                        child: _user.bio !=
                                                            ""
                                                            ? Container(
                                                            width: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                                0.56,
                                                            child: Text(
                                                              _user.bio,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                  14,
                                                                  fontWeight:
                                                                  FontWeight.w300),
                                                              textAlign:
                                                              TextAlign
                                                                  .left,
                                                            ))
                                                            : Container()),
                                                  ]),
                                            )
                                          ]),
                                      Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: <Widget>[
                                              GestureDetector(
                                                  child: detailsWidget(
                                                     "56",
                                                      'totalscore',
                                                     Icons.score,
                                                      20),
                                                  onTap: () {

                                                  }),
                                              new Container(
                                                height: 30.0,
                                                width: 1.0,
                                                color: Colors.white30,
                                                margin:
                                                const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0),
                                              ),
                                              GestureDetector(
                                                  child: detailsWidget(
                                                    "130",
                                                      'followers',
                                                      Icons.people,
                                                      20),
                                                  onTap: () {

                                                  }),
                                              new Container(
                                                height: 30.0,
                                                width: 1.0,
                                                color: Colors.white30,
                                                margin:
                                                const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0),
                                              ),
                                              GestureDetector(
                                                  child: detailsWidget(
                                                     "199",
                                                      'following',
                                                      Icons.people_outline,
                                                      20),
                                                  onTap: () {

                                                  }),
                                            ],
                                          )),
                                    ]),
                                  )),
                            ),
                            floating: true,
                            pinned: false,
                            snap: true,
                            expandedHeight: 190,
                            backgroundColor: Colors.blue,

                          ),



                    ]);
                  }))
                  : CustomScrollView();

  }



  Widget detailsWidget(
      String count, String label, IconData _icon, double size) {
    return Container(
        constraints: new BoxConstraints(
          minWidth: 100.0,
        ),
        alignment: Alignment.center,
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(children: [
                Icon(
                  _icon,
                  size: size,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(count,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        color: Colors.white),
                    textAlign: TextAlign.left)
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(label,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w100)),
              )
            ],
          )
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}
