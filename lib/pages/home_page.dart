import 'package:factura/pages/receptor_page.dart';
import 'package:factura/pages/settings_page.dart';
import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';

import 'package:factura/pages/organization_page.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PreferenciasUsuario prefs = PreferenciasUsuario();
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
            label: 'Documentos',
            icon: new Icon(Icons.location_city),
          ),
          BottomNavigationBarItem(
            label: 'Configuración',
            icon: new Icon(Icons.settings),
          ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.person), title: Text('Profile'))
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    if (prefs.apiValid == false) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Alerta'),
                content: Text('Debe ingresar una apiKey válida'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Ok'))
                ],
              ));
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}
