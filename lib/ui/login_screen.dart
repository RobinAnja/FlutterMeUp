import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_up/ui/home_screen.dart';
import 'package:flutter_me_up/ui/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  User user;
  final GoogleSignIn _googleSignIn = GoogleSignIn();



  Future<bool> authenticateUserFuture(FirebaseUser user) async {
    print("Inside authenticateUser");
    final QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    if (docs.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
    await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    return user;
  }


  Future<void> addDataToDb(FirebaseUser currentUser) async {
    print("Inside addDataToDb Method");

    _firestore
        .collection("display_names")
        .document(currentUser.displayName)
        .setData({'displayName': currentUser.displayName});

    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        displayName: currentUser.displayName,
        photoUrl: currentUser.photoUrl,
        followers: 0,
        following: 0,
        bio: '',
        posts: 0,
        phone: '');

    //  Map<String, String> mapdata = Map<String, dynamic>();

    //  mapdata = user.toMap(user);

    return _firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light, // or use Brightness.dark

        centerTitle: true,
        elevation: 0.0,
        title: const Text('Gūenther',
            style: const TextStyle(
                fontFamily: "Bangers", color: Colors.black, fontSize: 30.0)),),
      body: Center(
        child: GestureDetector(
          child: Container(
            width: 250.0,
            height: 50.0,
            decoration: BoxDecoration(
                color: Color(0xFF4285F4),
                border: Border.all(color: Colors.black)),
            child: Row(
              children: <Widget>[
                Image.asset('assets/google_icon.jpg'),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text('Sign in with Google',
                      style: TextStyle(color: Colors.white, fontSize: 16.0)),
                )
              ],
            ),
          ),
          onTap: () {
            signIn().then((user) {
              if (user != null) {
                authenticateUserFuture(user);
              } else {
                print("Error");
              }
            });
          },
        ),
      ),
    );
  }

  void authenticateUser(FirebaseUser user) {
    print("Inside Login Screen -> authenticateUser");
    authenticateUserFuture(user).then((value) {
      if (value) {
        print("VALUE : $value");
        print("INSIDE IF");
        addDataToDb(user).then((value) {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        print("INSIDE ELSE");
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
