import 'package:flutter/material.dart';
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
  OrgProvider orgInfo = OrgProvider();

  DateTime _dateTime1 = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 30);
  DateTime _dateTime2 =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Historial')),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
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

                            var dateYearFiveLess = new DateTime(date.year - 6);
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
                                        })
                                    });
                          }),
                      Text(
                          _dateTime1 == null
                              ? formatter.format(
                                  DateTime(now.year, now.month, now.day - 30))
                              : formatter.format(_dateTime1),
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RaisedButton(
                          child: Text('Hasta'),
                          textColor: Colors.white,
                          color: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onPressed: () {
                            var date = new DateTime.now();
                            var dateYearFiveLess = new DateTime(date.year - 6);
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
                                      })
                                    });
                          }),
                      Text(
                          _dateTime2 == null
                              ? formatter.format(DateTime.now())
                              : formatter.format(_dateTime2),
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: FutureBuilder(
              future: orgInfo.cargarReg(
                  formatter.format(_dateTime2), formatter.format(_dateTime1)),
              builder: (BuildContext context,
                  AsyncSnapshot<RegistryModel> snapshot) {
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
          ),
        ],
      ),
    );
  }
}

class _ListaRegistros extends StatelessWidget {
  final List<Datum> registros;

  _ListaRegistros(this.registros);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: registros.length,
      itemBuilder: (BuildContext context, int i) {
        final registro = registros[i];

        return ListTile(
          title: Text(
              '${registro.rznSocRecep} ${registro.rutRecep}-${registro.dv}'),
          subtitle: Text(
              'FOLIO: ${registro.folio} DTE: ${registro.tipoDte} Total: ${registro.mntTotal}'),
          trailing: IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
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
