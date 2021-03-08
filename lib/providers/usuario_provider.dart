import 'dart:convert';

import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyBfee9RTfIoFCnb5CRB3ANXc7dJdXdB7jQ';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    //Info que se va a ocupar para autenticar
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    //Guarda la respuesta, es decir tiene nuestro token de firebase que luego se conecta con la api de firebase
    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData));

    //Esto decodifica la respuesta
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);
    //Significa que es valido
    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];

      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      //Si no es valido nos envia un mensaje de error
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    //Info que se va a ocupar para autenticar
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    //Guarda la respuesta, es decir tiene nuestro token de firebase que luego se conecta con la api de firebase
    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData));
    //Esto decodifica la respuesta
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);
    //Significa que es valido
    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];

      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      //Si no es valido nos envia un mensaje de error
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> cambioClave(String email) async {
    //Info que se va a ocupar para autenticar
    final authData = {'email': email, 'requestType': 'PASSWORD_RESET'};
    //Guarda la respuesta, es decir tiene nuestro token de firebase que luego se conecta con la api de firebase
    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$_firebaseToken',
        body: json.encode(authData));
    //Esto decodifica la respuesta
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);
    //Significa que es valido
    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];

      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      //Si no es valido nos envia un mensaje de error
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }
}
