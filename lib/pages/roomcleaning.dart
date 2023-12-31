
import 'package:flutter/material.dart';
import 'package:jiraniapp/pages/roomcleaningbody.dart';

class roomcleaning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "oswald"),
      home: RoomCleaning(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RoomCleaning extends StatefulWidget {
  RoomCleaning({Key ? key}) : super(key: key);

  @override
  _RoomCleaningState createState() => _RoomCleaningState();
}

class _RoomCleaningState extends State<RoomCleaning> {
  int _currentindex = 0;
  List tabs = [
    rcbody(),
    Container(
      color: Colors.greenAccent,
    ),
    Container(
      color: Colors.pink,
    ),
    Container(
      color: Colors.yellow,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: tabs[_currentindex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentindex,
            elevation: 5,
            backgroundColor: Colors.white54,
            selectedItemColor: Colors.red[800],
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(size: 30),
            selectedFontSize: 15,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_basket,
                ),
                label: "shopping",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: "Settings",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.star,
                ),
                label: "star",
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentindex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}