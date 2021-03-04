import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:factura/model/registryModel.dart';
import 'package:factura/pages/pdf_page.dart';
import 'package:factura/providers/organizationProvider.dart';

class HisPage extends StatefulWidget {
  HisPage({Key key}) : super(key: key);

  @override
  _HisPageState createState() => _HisPageState();
}

class _HisPageState extends State<HisPage> {
  PreferenciasUsuario prefs = PreferenciasUsuario();
  OrgProvider orgInfo = OrgProvider();

  bool desplegar = true;

  TextEditingController rutt = TextEditingController();

  DateTime _dateTime1 = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 30);
  DateTime _dateTime2 =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');

  List _dteList = ['Factura', 'Boleta'];
  String _dteVal;

  String tipoDteVal = "33";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Center(child: Text('Historial')),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RaisedButton(
                          child: Text('Desde'),
                          textColor: Colors.white,
                          color: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onPressed: () {
                            var date = new DateTime.now();

                            var newDateThirtyDaysLess = new DateTime(
                                date.year, date.month, date.day - 30);

                            var dateYearFiveLess = new DateTime(date.year - 1);
                            var dateYearActually = new DateTime(date.year + 1);

                            showDatePicker(
                                    context: context,
                                    initialDate: _dateTime1 == null
                                        ? newDateThirtyDaysLess
                                        : _dateTime1,
                                    firstDate: dateYearFiveLess,
                                    lastDate: dateYearActually)
                                .then((date) => {
                                      if (date != null)
                                        setState(() {
                                          _dateTime1 = date == null
                                              ? newDateThirtyDaysLess
                                              : date;
                                          desplegar = false;
                                        })
                                    });
                          }),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: Text(
                            _dateTime1 == null
                                ? formatter.format(
                                    DateTime(now.year, now.month, now.day - 30))
                                : formatter.format(_dateTime1),
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      ),
                      RaisedButton(
                          child: Text('Hasta'),
                          textColor: Colors.white,
                          color: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onPressed: () {
                            var date = new DateTime.now();
                            var dateYearFiveLess = new DateTime(date.year - 1);
                            var dateYearActually = new DateTime(date.year + 1);
                            showDatePicker(
                                    context: context,
                                    initialDate: _dateTime2 == null
                                        ? DateTime.now()
                                        : _dateTime2,
                                    firstDate: dateYearFiveLess,
                                    lastDate: dateYearActually)
                                .then((date) => {
                                      setState(() {
                                        _dateTime2 = date == null
                                            ? DateTime.now()
                                            : date;
                                        desplegar = false;
                                      })
                                    });
                          }),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: Text(
                            _dateTime2 == null
                                ? formatter.format(DateTime.now())
                                : formatter.format(_dateTime2),
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: EdgeInsets.all(15),
                        child: TextFormField(
                          maxLength: 8,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                          ],
                          controller: rutt,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.deepPurple,
                          style: TextStyle(color: Colors.deepPurple),
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: -100),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            prefixText: 'Rut : ',
                            prefixStyle: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold),
                            labelText: 'Ej: 70657324',
                            labelStyle: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold),
                            prefixIcon: Icon(
                              Icons.domain,
                              color: Colors.deepPurple,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              desplegar = false;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.deepPurple, width: 2.0),
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text(_dteList[0].toString()),
                                value: _dteVal,
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 18),
                                onChanged: (value) {
                                  setState(() {
                                    _dteVal = value;
                                    if (_dteVal.toString() == 'Factura') {
                                      tipoDteVal = "33";
                                    } else if (_dteVal.toString() == 'Boleta') {
                                      tipoDteVal = "39";
                                    }
                                    desplegar = false;
                                  });
                                },
                                items: _dteList.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                        child: Text('Buscar'),
                        textColor: Colors.white,
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        onPressed: () {
                          setState(() {
                            desplegar = true;
                          });
                        })
                  ],
                ),
              ],
            ),
          ),
          desplegar == false
              ? Text('')
              : returnInfo(
                  _dateTime1,
                  _dateTime2,
                  tipoDteVal,
                  rutt.text == "" || rutt.text == null
                      ? null
                      : int.parse(rutt.text))
        ],
      ),
    );
  }

  Widget returnInfo(
      DateTime fechaDesde, DateTime fechaHasta, String tipoDte, int rutRec) {
    return Expanded(
      flex: 4,
      child: FutureBuilder(
        future: orgInfo.cargarReg(formatter.format(_dateTime2),
            formatter.format(_dateTime1), tipoDte, rutRec),
        builder: (BuildContext context, AsyncSnapshot<RegistryModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data == null) {
            return Center(
                child: Text(
                    'No se encontraron datos de los DTE, inténtalo mas tarde'));
          } else {
            return _ListaRegistros(snapshot.data.data);
          }
        },
      ),
    );
  }
}

class _ListaRegistros extends StatefulWidget {
  final List<Datum> registros;

  _ListaRegistros(this.registros);

  @override
  __ListaRegistrosState createState() => __ListaRegistrosState();
}

class __ListaRegistrosState extends State<_ListaRegistros> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.registros.length,
      itemBuilder: (BuildContext context, int i) {
        final registro = widget.registros[i];
        ArsProgressDialog _progressDialog;

        _progressDialog = ArsProgressDialog(context,
            blur: 2,
            backgroundColor: Color(0x33000000),
            animationDuration: Duration(milliseconds: 500));

        return ListTile(
          title: Text(
              '${registro.tipoDte == 33 ? registro.rznSocRecep : "Boleta"} ${registro.tipoDte == 33 ? registro.rutRecep : ""} ${registro.tipoDte == 33 ? registro.dv : ""}'),
          subtitle: Text(
              'FOLIO: ${registro.folio} DTE: ${registro.tipoDte} Total: ${registro.mntTotal}'),
          trailing: IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              _progressDialog.show();
              String codDte = registro.tipoDte.toString();
              String folio = registro.folio.toString();
              String pdfString;

              OrgProvider orgInfo = OrgProvider();

              await orgInfo.cargarDte(codDte, folio).then((value) {
                pdfString = value.pdf;
              });

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PdfPage(
                        pdfString: pdfString,
                      )));
            },
          ),
        );
      },
    );
  }
}
