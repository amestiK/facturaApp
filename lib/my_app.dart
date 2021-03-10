import 'package:factura/bloc/provider.dart';
import 'package:factura/pages/boleta_page.dart';
import 'package:factura/pages/factura_page.dart';
import 'package:factura/pages/login_page.dart';
import 'package:factura/pages/home_page.dart';
import 'package:factura/pages/his_page.dart';
import 'package:factura/pages/recuperar_clave.dart';
import 'package:factura/pages/registro_page.dart';
import 'package:factura/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:factura/pages/organization_page.dart';
import 'package:factura/pages/receptor_page.dart';
import 'package:factura/pages/pdf_page.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: FlavorBanner(
        color: Colors.blue,
        location: BannerLocation.topEnd,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: 'LoginPage',
          routes: {
            'HistoryPage': (BuildContext context) => HisPage(),
            'LoginPage': (BuildContext context) => LoginPage(),
            'HomePage': (BuildContext context) => Home(),
            'ReceptorPage': (BuildContext context) => ReceptorPage(),
            'OrganizationPage': (BuildContext context) => OrganizationPage(),
            'BoletaPage': (BuildContext context) => BoletaPage(),
            'FacturaPage': (BuildContext context) => FacturaPage(),
            'PdfPage': (BuildContext context) => PdfPage(),
            'Preferencias': (BuildContext context) => SettingsPage(),
<<<<<<< HEAD
=======
            'registro': (BuildContext context) => RegistroPage(),
            'recuperar': (BuildContext context) => RecuperarPage()
>>>>>>> ramaBenja
          },
        ),
      ),
    );
  }
}
