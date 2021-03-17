import 'package:factura/model/organizationModel.dart';
import 'package:factura/pages/receptor_page.dart';
import 'package:factura/providers/InfoProvider.dart';
import 'package:factura/providers/organizationProvider.dart';
import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrganizationPage extends StatefulWidget {
  OrganizationPage({Key key}) : super(key: key);

  @override
  _OrganizationPageState createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  final infoProvider = new InfoProvider();
  final orgProvider = new OrgProvider();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String fechaFormateada = '';
  List<Actividade> act = [];
  PreferenciasUsuario prefs = PreferenciasUsuario();

  String rutEmi;
  String rznEmi;
  String giroEmi;
  String actEmi;
  String dirEmi;
  String cmaEmi;
  String codEmi;

  String giro = '';
  String actEco = '';
  String codActEco = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text('Factura')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        child: crearListOrg(),
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60.0),
            Text('Bienvenido: ' + prefs.nombreGoogle,
                style: TextStyle(fontSize: 20.0))
          ],
        ),
      ),
    );
  }

  Widget crearListOrg() {
    return FutureBuilder(
      future: orgProvider.cargarOrg(),
      builder:
          (BuildContext context, AsyncSnapshot<OrganizationModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final infoOrg = snapshot.data;

          act = infoOrg.actividades;

          fechaFormateada = formatter.format(infoOrg.resolucion.fecha);

          for (var i = 0; i < act.length; i++) {
            if (act[i].actividadPrincipal == true) {
              giro = act[i].giro;
              actEco = act[i].actividadEconomica;
              prefs.actEmi = codActEco = act[i].codigoActividadEconomica;
            }
          }
          return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, i) => Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Center(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                                width: MediaQuery.of(context).size.width - 8,
                                child: Text(
                                  'Bienvenido ${prefs.rznEmi = infoOrg.razonSocial}',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text('${prefs.rutEmi = infoOrg.rut}',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Text('${infoOrg.nombreFantasia}',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text('${infoOrg.email}',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Text('${infoOrg.telefono}',
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text('${prefs.dirEmi = infoOrg.direccion}',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Text(
                                'Codigo Sucursal: ${prefs.codEmi = infoOrg.cdgSiiSucur}',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                                '${prefs.giroEmi = infoOrg.glosaDescriptiva}',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Text(
                                '${prefs.cmaEmi = infoOrg.direccionRegional}',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text('${actEco == null ? '' : actEco}',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Text(
                                '${infoOrg.web == null ? 'Web : No especificada' : infoOrg.web}',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                                'Resolución\nFecha : ${fechaFormateada == null ? 'Fecha : ' : fechaFormateada}\nNumero: ${infoOrg.resolucion.numero} ',
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      )
                    ],
                  ));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(
              child: Text(
                  'No se encuentran datos del receptor o intentelo luego'));
        }
      },
    );
  }
}
