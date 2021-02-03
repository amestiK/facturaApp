import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  Future<void> initPrefs() async {
    if (_prefs == null) {
      this._prefs = await SharedPreferences.getInstance();
    }
  }

  //GET Y SET del GENERO
  /*get genero {
    return _prefs.getInt('genero') ?? 1;
  }

  set genero (int value){
    _prefs.setInt('genero', value);
  }

   //GET Y SET del COLORSECUNDARIO
  get colorSecundario {
    return _prefs.getBool('colorSecundario') ?? 1;
  }

  set colorSecundario (bool value){
    _prefs.setBool('colorSecundario', value);
  }*/

  get combo {
    return _prefs.getString('combo') ?? 'one';
  }

  set combo(String value) {
    _prefs.setString('combo', value);
  }

  //GET Y SET de ApiKey
  get apiKey {
    return _prefs.getString('apiKey') ?? '';
  }

  set apiKey(String value) {
    _prefs.setString('apiKey', value);
  }

  //GET Y SET de la ultima pagina
  /*get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'LoginPage';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }*/

  /*bool _colorSecundario;
  int _genero;
  String _nombre;
  */

}
