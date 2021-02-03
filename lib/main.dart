import 'package:factura/bloc/provider.dart';
import 'package:factura/pages/boleta_page.dart';
import 'package:factura/pages/factura_exenta_page.dart';
import 'package:factura/pages/factura_page.dart';
import 'package:factura/pages/login_page.dart';
import 'package:factura/pages/home_page.dart';
import 'package:factura/pages/settings_page.dart';
import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:factura/pages/organization.dart';
import 'package:factura/pages/receptor.dart';
import 'package:factura/pages/pdf_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'PreferenciasUsuario',
        routes: {
          'LoginPage': (BuildContext context) => LoginPage(),
          'HomePage': (BuildContext context) => Home(),
          'ReceptorPage': (BuildContext context) => ReceptorPage(),
          'OrganizationPage': (BuildContext context) => OrganizationPage(),
          'BoletaPage': (BuildContext context) => BoletaPage(),
          'FacExePage': (BuildContext context) => FacExePage(),
          'FacturaPage': (BuildContext context) => FacturaPage(),
          'PdfPage': (BuildContext context) => PdfPage(),
          'PreferenciasUsuario': (BuildContext context) => SettingsPage(),
          //SettingsPage.routeName: (BuildContext context) => SettingsPage(),
        },
      ),
    );
  }
}
