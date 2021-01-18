import 'package:flutter/material.dart';
import 'package:factura/model/InfoModel.dart';
import 'package:dart_rut_validator/dart_rut_validator.dart';

import 'package:factura/providers/InfoProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Var de infoModel.dart e infoProvider.dart.
  InfoModel info = new InfoModel();
  final infoProvider = new InfoProvider();
  //Var para controlar el formulario mediante Key(id).
  final _formKey = GlobalKey<FormState>();
  //Var para Listas
  List<Actividade> act = [];
  List<Sucursale> suc = [];
  //Var para controlar validaciones.
  TextEditingController rutt = TextEditingController();
  //Var para informacion de la factura.
  String rut;
  String giro = "";
  String actEconomica = "";
  String codActEco = "";
  String codSiiSuc = "";
  String comuna = "";
  String dir = "";
  String ciudad = "";
  String tel = "";
  //Var para cambiar la visibilidad del widget que muestra la informacion de la factura.
  bool _visDataFact = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(child: Text('Adminsitración factura')),
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Center(
                        child: TextFormField(
                          controller: rutt,
                          validator: RUTValidator().validator,
                          // validator: (value) =>
                          //     value.isEmpty ? "Ingrese un Rut" : null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Ej: 70657324-7'),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  rut = RUTValidator.formatFromText(rutt.text);
                                  _visDataFact = true;
                                });
                              }
                            },
                            child: Text('Buscar')),
                        RaisedButton(
                          onPressed: () {
                            setState(() {
                              _limpiarForm();
                            });
                          },
                          child: Text('Limpiar'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )),
            Expanded(
                flex: 2,
                child: Visibility(
                  visible: _visDataFact,
                  child: Container(
                    child: _crearListado(rut),
                  ),
                ))
          ],
        ));
  }

  void _limpiarForm() {
    info.rut = '';
    info.razonSocial = '';
    info.email = '';
    info.telefono = '';
    info.direccion = '';
    info.comuna = '';
    giro = '';
    actEconomica = '';
    codActEco = '';
    codSiiSuc = '';
    comuna = '';
    dir = '';
    tel = '';
  }

  Widget _crearListado(String ruttt) {
    return FutureBuilder(
      future: infoProvider.cargarInfo(ruttt),
      builder: (BuildContext context, AsyncSnapshot<InfoModel> snapshot) {
        if (snapshot.hasData) {
          final info = snapshot.data;

          act = info.actividades;
          suc = info.sucursales;

          for (var i = 0; i < suc.length; i++) {
            codSiiSuc = suc[i].cdgSiiSucur;
            comuna = suc[i].comuna;
            dir = suc[i].direccion;
            ciudad = suc[i].ciudad;
            if (suc[i].telefono == null) {
              suc[i].telefono = '';
            }
            tel = suc[i].telefono;
          }

          for (var i = 0; i < act.length; i++) {
            if (act[i].actividadPrincipal == true) {
              giro = act[i].giro;
              actEconomica = act[i].actividadEconomica;
              codActEco = act[i].codigoActividadEconomica;
            }
          }

          return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, i) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 150, 8),
                              child: Text('${info.rut}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic)),
                            ),
                          ),
                          Container(
                            color: Colors.red,
                            child: Text('${info.razonSocial}',
                                style: TextStyle(
                                    fontSize: 15, fontStyle: FontStyle.italic)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 120, 8),
                            child: Text('${info.email}',
                                style: TextStyle(
                                    fontSize: 15, fontStyle: FontStyle.italic)),
                          ),
                          Text('${info.telefono}',
                              style: TextStyle(
                                  fontSize: 15, fontStyle: FontStyle.italic)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 120, 8),
                            child: Text('${info.direccion}',
                                style: TextStyle(
                                    fontSize: 15, fontStyle: FontStyle.italic)),
                          ),
                          Text('${info.comuna}',
                              style: TextStyle(
                                  fontSize: 15, fontStyle: FontStyle.italic)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Actividad',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$giro',
                                style: TextStyle(
                                    fontSize: 15, fontStyle: FontStyle.italic)),
                          ),
                        ],
                      ),
                      Text('$actEconomica'),
                      Text('$codActEco'),
                      Text('$codSiiSuc'),
                      Text('$comuna'),
                      Text('$dir'),
                      Text('$tel'),
                    ],
                  ));
        } else {
          _visDataFact = false;
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
