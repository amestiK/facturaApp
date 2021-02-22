import 'package:factura/bloc/provider.dart';

import 'package:factura/pages/boleta_page.dart';
import 'package:factura/pages/factura_exenta_page.dart';
import 'package:factura/pages/factura_page.dart';
import 'package:factura/pages/login_page.dart';
import 'package:factura/pages/home_page.dart';
import 'package:factura/pages/his_page.dart';
import 'package:factura/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:factura/pages/organization_page.dart';
import 'package:factura/pages/receptor_page.dart';
import 'package:factura/pages/pdf_page.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
  FlavorConfig(
    name: "",
    color: Colors.red,
    location: BannerLocation.topStart,
    variables: {
      "baseUrl": "https://dev-api.haulmer.com",
      "apiKey": "928e15a2d14d4a6292345f04960f4bd3"
    },
  );
}*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      color: Colors.blue,
      location: BannerLocation.topEnd,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: 'HomePage',
        routes: {
          'HistoryPage': (BuildContext context) => HisPage(),
          'LoginPage': (BuildContext context) => LoginPage(),
          'HomePage': (BuildContext context) => Home(),
          'ReceptorPage': (BuildContext context) => ReceptorPage(),
          'OrganizationPage': (BuildContext context) => OrganizationPage(),
          'BoletaPage': (BuildContext context) => BoletaPage(),
          'FacExePage': (BuildContext context) => FacExePage(),
          'FacturaPage': (BuildContext context) => FacturaPage(),
          'PdfPage': (BuildContext context) => PdfPage(),
          'Preferencias': (BuildContext context) => SettingsPage()
        },
      ),
    );
    /*return Provider(
      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'HomePage',
        routes: {
          'HistoryPage': (BuildContext context) => HisPage(),
          'LoginPage': (BuildContext context) => LoginPage(),
          'HomePage': (BuildContext context) => Home(),
          'ReceptorPage': (BuildContext context) => ReceptorPage(),
          'OrganizationPage': (BuildContext context) => OrganizationPage(),
          'BoletaPage': (BuildContext context) => BoletaPage(),
          'FacExePage': (BuildContext context) => FacExePage(),
          'FacturaPage': (BuildContext context) => FacturaPage(),
          'PdfPage': (BuildContext context) => PdfPage(),
          'Preferencias': (BuildContext context) => SettingsPage()
        },
      ),
    );*/
  }
}
