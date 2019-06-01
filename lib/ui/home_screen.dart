import 'package:flutter_me_up/ui/fancy_fab.dart';
import 'package:flutter_me_up/ui/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_up/ui/list.dart';
import 'package:flutter_me_up/ui/animated_bottom_bar.dart';
import 'package:flutter_me_up/ui/search_screen.dart';

class HomeScreen extends StatefulWidget {


  @override
  HomeScreenState createState() => HomeScreenState();
}

PageController pageController;

class HomeScreenState extends State<HomeScreen> {

  int selectedBarIndex = 0;

  navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      this.selectedBarIndex = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FancyFab(),
      body: new PageView(
        children: [
          new Container(
            color: Colors.white,
            child: Home(),
          ),
          new Container(color: Colors.white, child: SearchScreen()),

          new Container(color: Colors.white, child: ProfileScreenNew()),


        ],
        controller: pageController,
        physics: new NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: AnimatedBottomBar(


        barItems: <BarItem>[
          BarItem(
              text: "Home",
              iconData: Icons.home,
              color: Colors.blue

          ),
          BarItem(
              text: "Suche",
              iconData: Icons.search,
              color: Colors.blue
          ),
          BarItem(
              text: "Profil",
              iconData: Icons.person,
              color: Colors.blue
          ),

        ],

        animationDuration: const Duration(milliseconds: 150),
        barStyle: BarStyle(
          fontSize: 16.0,
          iconSize: 24.0,
        ),
        onBarTap: (index) {
          navigationTapped(index);
        },
      ),

    );
  }
}