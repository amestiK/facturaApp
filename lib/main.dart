import 'package:factura/bloc/provider.dart';
import 'package:factura/pages/boleta_page.dart';
import 'package:factura/pages/factura_exenta_page.dart';
import 'package:factura/pages/factura_page.dart';
import 'package:factura/pages/login_page.dart';
import 'package:factura/pages/home_page.dart';
import 'package:factura/pages/his_page.dart';
import 'package:flutter/material.dart';
import 'package:factura/pages/organization_page.dart';
import 'package:factura/pages/receptor_page.dart';
import 'package:factura/pages/pdf_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'FacturaPage',
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
        },
      ),
    );
  }
}
