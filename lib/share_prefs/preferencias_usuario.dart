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

  //Get y Set de los valores del receptor
  get rutEmi {
    return _prefs.getString('rutEmi') ?? '';
  }

  set rutEmi(String value) {
    _prefs.setString('rutEmi', value);
  }

  get rznEmi {
    return _prefs.getString('rznEmi') ?? '';
  }

  set rznEmi(String value) {
    _prefs.setString('rznEmi', value);
  }

  get giroEmi {
    return _prefs.getString('giroEmi') ?? '';
  }

  set giroEmi(String value) {
    _prefs.setString('giroEmi', value);
  }

  get actEmi {
    return _prefs.getString('actEmi') ?? '';
  }

  set actEmi(String value) {
    _prefs.setString('actEmi', value);
  }

  get dirEmi {
    return _prefs.getString('dirEmi') ?? '';
  }

  set dirEmi(String value) {
    _prefs.setString('dirEmi', value);
  }

  get cmaEmi {
    return _prefs.getString('cmaEmi') ?? '';
  }

  set cmaEmi(String value) {
    _prefs.setString('cmaEmi', value);
  }

  get codEmi {
    return _prefs.getString('codEmi') ?? '';
  }

  set codEmi(String value) {
    _prefs.setString('codEmi', value);
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

  get nombreGoogle {
    return _prefs.getString('nombreGoogle') ?? '';
  }

  set nombreGoogle(String value) {
    _prefs.setString('nombreGoogle', value);
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

  get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

//GET Y SET de email
  get apiValid {
    return _prefs.getBool('apiValid') ?? false;
  }

  set apiValid(bool value) {
    _prefs.setBool('apiValid', value);
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
