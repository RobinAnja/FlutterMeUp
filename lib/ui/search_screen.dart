import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_up/ui/user.dart';
import 'package:flutter_me_up/resources/repository.dart';

import 'friend_profile_screen_new.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin<SearchScreen>{
  var _repository = Repository();
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  User _user = User();
  User currentUser;
  List<User> usersList = List<User>();
  String currentPage = "InstaSearchScreen";
  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.displayName = user.displayName;
      _user.photoUrl = user.photoUrl;
      _repository.fetchUserDetailsById(user.uid).then((user) {
        if(mounted)
        setState(() {
          currentUser = user;
        });
      });
      print("USER : ${user.displayName}");
      _repository.retrievePosts(user).then((updatedList) {
        if(mounted)

          setState(() {
          list = updatedList;
        });
      });
      _repository.fetchAllUsers(user).then((list) {
        if(mounted)

          setState(() {
          usersList = list;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        brightness: Brightness.light, // or use Brightness.dark
        backgroundColor: Colors.blue,
        elevation: 0,
        title:
        GestureDetector(
          child:
          Container(
            width: 350,
          child:
          Text('Suche')),
          onTap: (){
            showSearch(context: context, delegate: DataSearch(userList: usersList));

          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(userList: usersList));
            },
          )
        ],
      ),
      body:  Padding(
    padding: const EdgeInsets.only( left: 4, right: 4),


        child:
          ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),
                title: Text("Würzburg"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("München"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("Berlin"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("Hamburg"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("Shanghai"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("New York"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("London"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),
                title: Text("Würzburg"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("München"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("Berlin"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("Hamburg"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("Shanghai"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("New York"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("London"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),
                title: Text("Würzburg"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("München"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("Berlin"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("Hamburg"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("Shanghai"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("New York"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),

                title: Text("London"),
              ),
            ],
          )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DataSearch extends SearchDelegate<String> {

   List<User> userList;
   DataSearch({this.userList});



  @override
  List<Widget> buildActions(BuildContext context) {

    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
   // return Center(child: Container(width: 50.0, height: 50.0, color: Colors.red, child: Text(query),));
  }



  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? userList
        : userList.where((p) => p.displayName.startsWith(query)).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body:

      ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => ListTile(
            onTap: () {

              //   showResults(context);
              Navigator.push(context, CupertinoPageRoute(
                  builder: ((context) => FriendProfileScreenNew(name: suggestionsList[index].displayName))
              ));
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(suggestionsList[index].photoUrl),
            ),
            title: Text(suggestionsList[index].displayName),
          )),
    ));
  }


}
