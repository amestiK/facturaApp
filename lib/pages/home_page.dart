import 'package:factura/pages/settings_page.dart';
import 'package:flutter/material.dart';

import 'package:factura/pages/receptor_page.dart';
import 'package:factura/pages/organization_page.dart';

import 'boleta_page.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    OrganizationPage(),
    ReceptorPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            label: 'Receptor',
            icon: new Icon(Icons.location_city),
          ),
          BottomNavigationBarItem(
            label: 'settibgs',
            icon: new Icon(Icons.location_city),
          ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.person), title: Text('Profile'))
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
