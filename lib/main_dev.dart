import 'package:factura/my_app.dart';
import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

//Lista para APK
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  FlavorConfig(
    name: "DEVELOP",
    color: Colors.red,
    location: BannerLocation.topStart,
    variables: {
      "baseUrl": "https://dev-api.haulmer.com",
      "apiKey": "928e15a2d14d4a6292345f04960f4bd3"
    },
  );
  return runApp(MyApp());
}
