import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newbie_bartender/aggiungi_cocktail.dart';
import 'package:newbie_bartender/home_page.dart';
import 'package:newbie_bartender/login.dart';
import 'package:newbie_bartender/my_profile.dart';
import 'package:newbie_bartender/stats.dart';

class Navigation extends StatefulWidget {
  Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    Stats(),
    HomePage(),
    AggiungiCocktail(),
    MyProfile()
  ];

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 100,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            title: Text("Lista cocktail"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded),
            title: Text("Aggiungi"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            title: Text("Profilo"),
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTap,
      ),
    );
  }
}
