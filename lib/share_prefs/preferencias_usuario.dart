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
  get pathsii {
    return _prefs.getString("pathsii");
  }

  set pathsii(String value) {
    _prefs.setString("pathsii", value);
  }

  get image {
    return _prefs.getString("imagepath");
  }

  set image(String value) {
    _prefs.setString("imagepath", value);
  }

  DateTime getFecha() {
    final birthday = _prefs.getString('getFecha');
    return birthday == null ? null : DateTime.tryParse(birthday);
  }

  Future setFecha(DateTime value) async {
    final birthday = value.toIso8601String();
    return await _prefs.setString('fecha', birthday);
  }

  get descripcion {
    return _prefs.getString('descripcion') ?? '';
  }

  set descripcion(String value) {
    _prefs.setString('descripcion', value);
  }

  get fecha {
    return _prefs.getString('fecha') ?? '01/01/2021';
  }

  set fecha(String value) {
    _prefs.setString('fecha', value);
  }

  get combo {
    return _prefs.getString('combo') ?? 'one';
  }

  set combo(String value) {
    _prefs.setString('combo', value);
  }

  //GET Y SET de nombre
  get nombre {
    return _prefs.getString('nombre') ?? '';
  }

  set nombre(String value) {
    _prefs.setString('nombre', value);
  }

  //GET Y SET de telefono
  get telefono {
    return _prefs.getString('telefono') ?? '';
  }

  set telefono(String value) {
    _prefs.setString('telefono', value);
  }

  //GET Y SET de rut
  get rut {
    return _prefs.getInt('rut') ?? '';
  }

  set rut(String value) {
    _prefs.getInt(value);
  }

  //GET Y SET de ApiKey
  get apiKey {
    return _prefs.getString('apiKey') ?? '';
  }

  set apiKey(String value) {
    _prefs.setString('apiKey', value);
  }

  //GET Y SET de email
  get email {
    return _prefs.getString('email') ?? '';
  }

  set email(String value) {
    _prefs.setString('email', value);
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
