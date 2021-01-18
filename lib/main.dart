import 'package:flutter/material.dart';
import 'package:factura/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'HomePage',
      routes: {'HomePage': (BuildContext context) => HomePage()},
    );
  }
}
