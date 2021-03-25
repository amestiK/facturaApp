import 'package:factura/model/pdfModel.dart';
import 'package:factura/pages/pdf_page.dart';
import 'package:factura/providers/InfoProvider.dart';
import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FacturaPage extends StatefulWidget {
  final String rutEmi;
  final String rznEmi;
  final String giroEmi;
  final String actEmi;
  final String dirEmi;
  final String cmaEmi;
  final String codEmi;
  final String rutRec;
  final String razSocRec;
  final String giroRec;
  final String dirRec;
  final String comRec;

  const FacturaPage(
      {Key key,
      this.rutEmi,
      this.rznEmi,
      this.giroEmi,
      this.actEmi,
      this.dirEmi,
      this.cmaEmi,
      this.codEmi,
      this.rutRec,
      this.razSocRec,
      this.giroRec,
      this.dirRec,
      this.comRec})
      : super(key: key);

  @override
  _FacturaPageState createState() => _FacturaPageState();
}

class _FacturaPageState extends State<FacturaPage> {
  PreferenciasUsuario prefs = new PreferenciasUsuario();

  ArsProgressDialog _progressDialog;

  PdfModel pdfModel = new PdfModel();

  InfoProvider info = InfoProvider();

  final List<ItemFactura> rows = [];
  final List<Map<String, dynamic>> llenarDetalle = [];

  final _formKey = GlobalKey<FormState>();

  TextEditingController desCon = TextEditingController();
  TextEditingController quanCon = TextEditingController();
  TextEditingController amouCon = TextEditingController();
  TextEditingController totCon = TextEditingController();

  var f = NumberFormat('###,###');

  int indexOfItem;
  bool descState = true;
  bool exeArrayJson = true;
  bool sameDesc = false;

  String format = "";
  bool checkBoxValue80mm = false;
  bool checkBoxValueLetter = false;

  //Producto
  int montoTotalPro = 0;
  int quantity = 0;
  int amount = 0;
  int sum = 0;
  String pdfString;

  void addItemToList() {
    setState(() {
      rows.insert(
          rows.length,
          ItemFactura(
              desCon.text.length >= 20
                  ? desCon.text.substring(0, 20)
                  : desCon.text,
              int.parse(quanCon.text),
              int.parse(amouCon.text),
              montoTotalPro));
    });
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text('Detalle factura')),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  maxLength: 20,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[A-Z a-z0-9]')),
                  ],
                  enabled: descState,
                  keyboardType: TextInputType.text,
                  controller: desCon,
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    labelText: 'Descripción',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingresa una descripción';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      maxLength: 7,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                      ],
                      keyboardType: TextInputType.number,
                      controller: quanCon,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        labelText: 'Cantidad',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese un valor';
                        } else if (int.parse(value) > 1000000) {
                          return 'Cant. max 1000000';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      maxLength: 7,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                      ],
                      keyboardType: TextInputType.number,
                      controller: amouCon,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        labelText: 'Monto',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese un valor';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(200.0)),
                  child: Text('Agregar'),
                  onPressed: () {
                    for (var i = 0; i < rows.length; i++) {
                      if (rows[i].description == desCon.text) {
                        setState(() {
                          sameDesc = true;
                        });
                      }
                    }
                    if (rows.length == 10) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Alerta'),
                                content: Text(
                                    'Solo puede agregar 10 productos por Factura.'),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Ok'))
                                ],
                              ));
                    } else if (_formKey.currentState.validate() &&
                        descState == true &&
                        sameDesc == false) {
                      addItemToList();
                      desCon.clear();
                      quanCon.clear();
                      amouCon.clear();
                    } else if (sameDesc == true) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Alerta'),
                                content: Text(
                                    'No puede agregar 2 productos con la misma descripción'),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          sameDesc = false;
                                        });
                                      },
                                      child: Text('Ok'))
                                ],
                              ));
                    } else {
                      for (var i = 0; i < rows.length; i++) {
                        if (indexOfItem == i) {
                          rows[i].description = desCon.text;
                          rows[i].quantity = int.parse(quanCon.text);
                          rows[i].amount = int.parse(amouCon.text);
                        }
                      }
                      setState(() {
                        print(rows.toList());
                        descState = true;
                        desCon.clear();
                        quanCon.clear();
                        amouCon.clear();
                      });
                    }
                  },
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(200.0)),
                  child: Text('Modificar'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      for (var i = 0; i < rows.length; i++) {
                        if (indexOfItem == i) {
                          rows[i].description = desCon.text;
                          rows[i].quantity = int.parse(quanCon.text);
                          rows[i].amount = int.parse(amouCon.text);
                        }
                      }

                      setState(() {
                        desCon.clear();
                        quanCon.clear();
                        amouCon.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    value: prefs.checkBox80mm,
                    onChanged: prefs.checkBoxLetter == true
                        ? null
                        : (checkBoxValue80mm) {
                            setState(() {
                              prefs.checkBox80mm = checkBoxValue80mm;
                              prefs.formatFact = "80MM";
                            });
                          }),
                Text('80mm', style: TextStyle(fontWeight: FontWeight.bold)),
                Checkbox(
                    value: prefs.checkBoxLetter,
                    onChanged: prefs.checkBox80mm == true
                        ? null
                        : (checkBoxValueLetter) {
                            setState(() {
                              prefs.checkBoxLetter = checkBoxValueLetter;
                              prefs.formatFact = "LETTER";
                            });
                          }),
                Text('Carta', style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(columnSpacing: 3, columns: [
                              DataColumn(
                                label: Text('N°'),
                              ),
                              DataColumn(
                                label: Text('Item'),
                              ),
                              DataColumn(
                                label: Text('Cant.'),
                              ),
                              DataColumn(
                                label: Text('Neto'),
                              ),
                              DataColumn(
                                label: Text('Total'),
                              ),
                            ], rows: [
                              ...rows.map(
                                (element) => DataRow(
                                  cells: [
                                    DataCell(
                                      IconButton(
                                          alignment: Alignment.centerLeft,
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            print(rows.toList());
                                            setState(() {
                                              rows.removeAt(
                                                  rows.indexOf(element));
                                            });
                                          }),
                                    ),
                                    DataCell(
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: 50,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                desCon.text = element
                                                    .description
                                                    .toString();
                                                quanCon.text =
                                                    element.quantity.toString();
                                                amouCon.text =
                                                    element.amount.toString();
                                                indexOfItem =
                                                    rows.indexOf(element);
                                              });
                                            },
                                            child: Text(element.description
                                                .toString())),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                          width: 63,
                                          alignment: Alignment.centerRight,
                                          child: Text(f
                                              .format(element.quantity)
                                              .toString()
                                              .replaceAll(",", "."))),
                                    ),
                                    DataCell(
                                      Container(
                                          width: 63,
                                          alignment: Alignment.centerRight,
                                          child: Text(f
                                              .format(element.amount)
                                              .toString()
                                              .replaceAll(",", "."))),
                                    ),
                                    DataCell(
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3.5,
                                        alignment: Alignment.centerRight,
                                        child: Text(f
                                            .format(montoTotalPro =
                                                element.totalAmount =
                                                    element.quantity *
                                                        element.amount)
                                            .toString()
                                            .replaceAll(",", ".")),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataRow(cells: [
                                DataCell(Text(
                                  'Total neto',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(f
                                        .format(rows.fold(
                                            0,
                                            (prev, el) =>
                                                prev + el.amount * el.quantity))
                                        .toString()
                                        .replaceAll(",", ".")),
                                  ),
                                )
                              ]),
                              DataRow(cells: [
                                DataCell(Text(
                                  'Iva',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(f
                                      .format((rows.fold(
                                                  0,
                                                  (prev, el) =>
                                                      prev +
                                                      el.amount * el.quantity) *
                                              0.19)
                                          .round())
                                      .toString()
                                      .replaceAll(",", ".")),
                                )),
                              ]),
                              DataRow(cells: [
                                DataCell(Text(
                                  'Total bruto',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(f
                                        .format((rows.fold(
                                            0,
                                            (prev, el) =>
                                                prev +
                                                (el.totalAmount +
                                                        (el.totalAmount * 0.19))
                                                    .round())))
                                        .toString()
                                        .replaceAll(",", ".")),
                                  ),
                                )
                              ]),
                            ]),
                          )
                        ],
                      ),
                    );
                  },
                )),
            ButtonTheme(
              minWidth: 150,
              height: 60,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: RaisedButton(
                    child: Text('Enviar', style: TextStyle(fontSize: 18)),
                    textColor: Colors.white,
                    color: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200.0)),
                    onPressed: () {
                      if (prefs.checkBox80mm == false &&
                          prefs.checkBoxLetter == false) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Alerta'),
                                  content: Text(
                                      'Debe seleccionar un formato para el despliegue de la factura.'),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Ok'))
                                  ],
                                ));
                      } else if (rows.length != 0) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Confirmación'),
                                  content: Text(
                                      '¿Estás seguro que deseas emitir esta factura por el total de ${rows.fold(0, (prev, el) => prev + (el.totalAmount + (el.totalAmount * 0.19)).round())}?'),
                                  actions: [
                                    FlatButton(
                                        onPressed: () async {
                                          _progressDialog.show();
                                          int totAmou = int.parse(rows
                                              .fold(
                                                  0,
                                                  (prev, el) =>
                                                      prev +
                                                      el.amount * el.quantity)
                                              .toString());

                                          double value = (rows.fold(
                                                  0,
                                                  (prev, el) =>
                                                      prev +
                                                      el.amount * el.quantity) *
                                              0.19);

                                          int totIva = value.round();

                                          int totBruto = totAmou + totIva;

                                          int mntPeriodo = totBruto;

                                          int vlrPagar = totBruto;

                                          for (var i = 0;
                                              i < rows.length;
                                              i++) {
                                            llenarDetalle.add({
                                              // "NroLinDet": sum == sum
                                              //     ? sum = sum + 1
                                              //     : sum = sum,
                                              "NroLinDet": i + 1,
                                              "NmbItem": rows[i].description,
                                              "QtyItem": rows[i].quantity,
                                              "PrcItem": rows[i].amount,
                                              "MontoItem": rows[i].totalAmount
                                            });
                                          }

                                          print(rows.toList());
                                          print(llenarDetalle.toList());

                                          await info
                                              .postInfo(
                                                  prefs.formatFact,
                                                  widget.rutEmi,
                                                  widget.rznEmi,
                                                  widget.giroEmi,
                                                  widget.actEmi,
                                                  widget.dirEmi,
                                                  widget.cmaEmi,
                                                  widget.codEmi,
                                                  widget.rutRec,
                                                  widget.razSocRec,
                                                  widget.giroRec,
                                                  widget.dirRec,
                                                  widget.comRec,
                                                  totAmou,
                                                  totIva,
                                                  totBruto,
                                                  mntPeriodo,
                                                  vlrPagar,
                                                  llenarDetalle)
                                              .then((value) {
                                            print(value.pdf);
                                            setState(() {
                                              pdfString = value.pdf;
                                            });
                                          });

                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => PdfPage(
                                                        pdfString: pdfString,
                                                      )),
                                              (Route<dynamic> route) => false);
                                        },
                                        child: Text('Confirmar')),
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancelar'))
                                  ],
                                ));
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Alerta'),
                                  content: Text(
                                      'No puede hacer una factura sin productos'),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Ok'))
                                  ],
                                ));
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ItemFactura {
  String description;
  int quantity;
  int amount;
  int totalAmount;

  ItemFactura(this.description, this.quantity, this.amount, this.totalAmount);

  @override
  String toString() {
    return '{${this.description}, ${this.quantity}, ${this.amount}, ${this.totalAmount}}';
  }
}
