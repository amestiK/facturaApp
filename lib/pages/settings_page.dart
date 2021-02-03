import 'package:factura/providers/InfoProvider.dart';
import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettingsPage extends StatefulWidget {
  static final String routeName = 'settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  InfoProvider info = InfoProvider();

  bool _colorSecundario;
  int _genero;
  String _nombre = "Pedro";
  String dropdownValue;
  TextEditingController _textController;

  final prefs = new PreferenciasUsuario();

  /*_read() async {
    prefs = await PreferenciasUsuario.getInstance();
    setState(() {
      dropdownValue = prefs.getString(_key) ?? "one"; // get the value
    });
  }*/

  @override
  void initState() {
    super.initState();
    //prefs.ultimaPagina = SettingsPage.routeName;
    //_genero = prefs.genero;
    //_colorSecundario = prefs.colorSecundario;
    dropdownValue = prefs.combo;
    _textController = new TextEditingController(text: prefs.apiKey);
  }

  /*_setSelectedRadio(int valor) async{

    prefs.genero = valor;
    _genero = valor;
    setState(() {
      
    });

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ajustes'),
          backgroundColor: Colors.blue,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5.0),
              child: Text('Settings',
                  style:
                      TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _textController,
                //obscureText: true,
                decoration: InputDecoration(
                  labelText: 'ApiKey',
                  helperText: 'Ingrese apiKey',
                ),
                onChanged: (value) {
                  prefs.apiKey = value;
                },
              ),
            ),
            //DropDownButton Setting
            Divider(),
            Text('asdas',
                style:
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: DropdownButton<String>(
                value: dropdownValue,
                onChanged: (value) {
                  setState(() {
                    dropdownValue = value;
                  });
                  prefs.combo = value; // save value to SharedPreference
                },
                items: ['one', 'two', 'three']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )
          ],
        ));
  }
}
