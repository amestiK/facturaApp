import 'package:factura/Constants.dart';
import 'package:factura/pages/factura_page.dart';
import 'package:flutter/material.dart';
import 'package:factura/model/InfoModel.dart';
import 'package:dart_rut_validator/dart_rut_validator.dart';

import 'package:factura/providers/InfoProvider.dart';

class ReceptorPage extends StatefulWidget {
  const ReceptorPage({Key key}) : super(key: key);

  @override
  _ReceptorPageState createState() => _ReceptorPageState();
}

class _ReceptorPageState extends State<ReceptorPage> {
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
          title: Center(child: Text('Receptor')),
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
                          controller: rutt,
                          validator: RUTValidator().validator,
                          // validator: (value) =>
                          //     value.isEmpty ? "Ingrese un Rut" : null,
                          decoration: InputDecoration(
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
                                          child: Text('${info.rut}',
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
                                          child: Text('${info.razonSocial}',
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
                                              '${info.email == null ? 'No tiene email' : info.email}',
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
                                          child: Text('${info.telefono}',
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
                                          child: Text('${info.direccion}',
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
                                          child: Text('${info.comuna}',
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
                                          child: Text('$giro',
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
                                          child: Text('$actEconomica',
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
                                            'Actividad economica: $codActEco',
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
                                        child: Text('Sucursal: $codSiiSuc',
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
                                        child: Text('Comuna: $comuna',
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
                                        child: Text('Dirección: $dir',
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
                                        child: Text('Ciudad: $ciudad',
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
                                        child: Text('Teléfono: $tel',
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
      // Navigator.pushNamed(context, 'FacturaPage');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FacturaPage(
                rutRec: rutRec,
                razSocRec: razSocRec,
                giroRec: giroRec,
                dirRec: dirRec,
                comRec: comRec,
              )));
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
