import 'package:factura/Constants.dart';
import 'package:factura/pages/factura_page.dart';
import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:factura/model/InfoModel.dart';
import 'package:dart_rut_validator/dart_rut_validator.dart';

import 'package:factura/providers/InfoProvider.dart';
import 'package:flutter/services.dart';

class ReceptorPage extends StatefulWidget {
  const ReceptorPage({Key key}) : super(key: key);

  @override
  _ReceptorPageState createState() => _ReceptorPageState();
}

class _ReceptorPageState extends State<ReceptorPage> {
  //SharePreferences
  PreferenciasUsuario prefs = PreferenciasUsuario();
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

  bool desplegar = false;

  String rutEmi;
  String rznEmi;
  String giroEmi;
  String actEmi;
  String dirEmi;
  String cmaEmi;
  String codEmi;
  String actecoEmi;
  String rutRec;
  String razSocRec;
  String giroRec;
  String dirRec;
  String comRec;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[500],
          title: Center(child: Text('Documentos')),
          actions: [
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              color: Colors.deepPurple[500],
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 16, 20, 10),
                      child: Center(
                        child: TextFormField(
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          maxLength: 10,
                          controller: rutt,
                          validator: RUTValidator().validator,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9-]'))
                          ],
                          decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              prefixText: 'Rut : ',
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              prefixIcon: Icon(
                                Icons.domain,
                                color: Colors.white,
                              ),
                              prefixStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              labelText: 'Ej: 70657324-7'),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(200.0)),
                            color: Colors.deepPurple[700],
                            textColor: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  RUTValidator.formatFromText(rutt.text);
                                  _limpiarForm();
                                  desplegar = true;
                                });
                              }
                            },
                            child: Text('Buscar')),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200.0)),
                          color: Colors.deepPurple[700],
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              _limpiarForm();
                              rutt.clear();
                              desplegar = false;
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
                flex: 3,
                child: desplegar == false ? Text('') : _crearListado(rutt.text))
          ],
        ));
  }

  Widget _crearListado(String rut) {
    return FutureBuilder(
      future: infoProvider.cargarInfo(rut),
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

          rutRec = info.rut == null ? info.rut = "" : info.rut = info.rut;
          razSocRec = info.razonSocial == null
              ? info.razonSocial = ""
              : info.razonSocial.replaceAll(" ", "");
          giroRec = giro == null
              ? giro = ""
              : giro.replaceAll(" ", "").substring(0, 36);
          dirRec = info.direccion == null
              ? info.direccion = ""
              : info.direccion.replaceAll(" ", "");
          comRec = info.comuna == null ? "" : info.comuna.replaceAll(" ", "");

          return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, i) => Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                        child: Text(
                          'Información de la factura',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width - 20,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            color: Colors.deepPurple,
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 50, 10),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          child: Text(
                                              '${info.rut == null ? "" : info.rut}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          child: Text(
                                              '${info.razonSocial == null ? "" : info.razonSocial}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 50, 10),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          child: Text(
                                              '${info.email == null ? "" : info.email}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 10),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          child: Text(
                                              '${info.telefono == null ? "" : info.telefono}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 50, 10),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          child: Text(
                                              '${info.direccion == null ? "" : info.direccion}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 10),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          child: Text(
                                              '${info.comuna == null ? "" : info.comuna}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              35,
                                          child: Text(
                                              '${giro == null ? "" : giro}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              35,
                                          child: Text(
                                              '${actEconomica == null ? "" : actEconomica}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                35,
                                        child: Text(
                                            'Actividad economica: ${codActEco == null ? "" : codActEco}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Sucursal',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                35,
                                        child: Text(
                                            'Sucursal: ${codSiiSuc == null ? "" : codSiiSuc}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic)),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                35,
                                        child: Text(
                                            'Comuna: ${comuna == null ? "" : comuna}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic)),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                35,
                                        child: Text(
                                            'Dirección: ${dir == null ? "" : dir}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic)),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                35,
                                        child: Text(
                                            'Ciudad: ${ciudad == null ? "" : dir}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic)),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                35,
                                        child: Text(
                                            'Teléfono: ${tel == null ? "" : tel}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(
              child: Text(
                  'No se encontraron datos del receptor, inténtalo mas tarde'));
        }
      },
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Factura) {
      if (rutt.text != "" &&
          rutRec != null &&
          razSocRec != null &&
          giroRec != null &&
          giroRec != null &&
          dirRec != null &&
          comRec != null &&
          rutRec != "" &&
          razSocRec != "" &&
          giroRec != "" &&
          giroRec != "" &&
          dirRec != "" &&
          comRec != "" &&
          rutEmi != null &&
          rznEmi != null &&
          giroEmi != null &&
          actEmi != null &&
          dirEmi != null &&
          cmaEmi != null &&
          codEmi != null &&
          actecoEmi != null &&
          rutEmi != "" &&
          rznEmi != "" &&
          giroEmi != "" &&
          actEmi != "" &&
          dirEmi != "" &&
          cmaEmi != "" &&
          codEmi != "" &&
          actecoEmi != "") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FacturaPage(
                  rutEmi: prefs.rutEmi,
                  rznEmi: prefs.rznEmi,
                  giroEmi: prefs.giroEmi,
                  actEmi: prefs.actEmi,
                  dirEmi: prefs.dirEmi,
                  cmaEmi: prefs.cmaEmi,
                  codEmi: prefs.codEmi,
                  rutRec: rutRec,
                  razSocRec: razSocRec,
                  giroRec: giroRec,
                  dirRec: dirRec,
                  comRec: comRec,
                )));
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Alerta'),
                  content: Text(
                      'Debe ingresar un receptor o los datos del receptor encontrados no son suficientes para navegar a Factura'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Aceptar'))
                  ],
                ));
      }
    } else if (choice == Constants.Boleta) {
      Navigator.pushNamed(context, 'BoletaPage');
    } else if (choice == Constants.HistoryPage) {
      Navigator.pushNamed(context, 'HistoryPage');
    }
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
}
