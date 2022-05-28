import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/gfsPage.dart';
import 'package:gametuf/homeScreens/chatPage.dart';
import 'package:gametuf/homeScreens/notificationsPage.dart';
import 'package:gametuf/homeScreens/profilePage.dart';
import 'package:gametuf/homeScreens/rankPage.dart';
import 'package:gametuf/homeScreens/searchPage.dart';
import 'package:gametuf/playerSearch/psScreen.dart';
import 'package:gametuf/services/authService.dart';
import 'package:provider/provider.dart';

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final tabs = [
    // rankPage(),
    profilePage(),
    notificationsPage(),
    searchPage(),
    gfsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.assignment_outlined,
          //     color: Colors.black87,
          //   ),
          //   label: 'Rank',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black87,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_active,
              color: Colors.black87,
            ),
            label: 'notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black87,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_search,
              color: Colors.black87,
            ),
            label: 'Arp',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black87,
        onTap: _onItemTapped,
      ),
      body: Center(
        child: tabs.elementAt(_selectedIndex),
      ),
    );
  }
}
