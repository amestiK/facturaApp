import 'package:factura/model/pdfModel.dart';
import 'package:factura/pages/pdf_page.dart';
import 'package:factura/providers/InfoProvider.dart';
import 'package:flutter/material.dart';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/services.dart';

class FacturaPage extends StatefulWidget {
  final String rutRec;
  final String razSocRec;
  final String giroRec;
  final String dirRec;
  final String comRec;

  const FacturaPage(
      {Key key,
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

  int indexOfItem;
  bool descState = true;
  bool exeArrayJson = true;
  bool sameDesc = false;

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
          ItemFactura(rows.length, desCon.text.substring(0, 20),
              int.parse(quanCon.text), int.parse(amouCon.text), montoTotalPro));
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
            Padding(
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                maxLength: 4,
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
                    return 'Ingrese un valor en cantidad';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                maxLength: 6,
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
                    return 'Ingrese un valor en el monto';
                  }
                  return null;
                },
              ),
            ),
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
                if (_formKey.currentState.validate() &&
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
                    if (indexOfItem == rows[i].index) {
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
            Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: rows.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(columnSpacing: 16, columns: [
                              DataColumn(
                                label: Text('N°Item'),
                              ),
                              DataColumn(
                                label: Text('Descripción'),
                              ),
                              DataColumn(
                                label: Text('Cantidad'),
                              ),
                              DataColumn(
                                label: Text('Precio'),
                              ),
                              DataColumn(
                                label: Text('Precio total'),
                              ),
                            ], rows: [
                              ...rows.map(
                                (element) => DataRow(
                                  cells: [
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                print(rows.toList());
                                                setState(() {
                                                  rows.removeAt(element.index);
                                                });
                                              }),
                                          Text(element.index.toString()),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              desCon.text = element.description
                                                  .toString();
                                              quanCon.text =
                                                  element.quantity.toString();
                                              amouCon.text =
                                                  element.amount.toString();
                                              indexOfItem = element.index;
                                              descState = false;
                                            });
                                          },
                                          child: Text(
                                              element.description.toString())),
                                    ),
                                    DataCell(
                                      Text(element.quantity.toString()),
                                    ),
                                    DataCell(
                                      Text(element.amount.toString()),
                                    ),
                                    DataCell(
                                      Text((montoTotalPro = element
                                                  .totalAmount =
                                              element.quantity * element.amount)
                                          .toString()),
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
                                  Text(rows
                                      .fold(
                                          0,
                                          (prev, el) =>
                                              prev + el.amount * el.quantity)
                                      .toString()),
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
                                DataCell(Text((rows.fold(
                                            0,
                                            (prev, el) =>
                                                prev +
                                                el.amount * el.quantity) *
                                        0.19)
                                    .toString())),
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
                                  Text((rows.fold(
                                          0,
                                          (prev, el) =>
                                              prev +
                                              (el.totalAmount +
                                                  (el.totalAmount * 0.19))))
                                      .toString()),
                                )
                              ]),
                            ]),
                          )
                        ],
                      ),
                    );
                  },
                )),
            RaisedButton(
                child: Text('Enviar'),
                textColor: Colors.white,
                color: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200.0)),
                onPressed: () {
                  if (rows.length != 0) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Confirmación'),
                              content: Text(
                                  '¿Estás seguro que deseas emitir esta factura?'),
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

                                      for (var i = 0; i < rows.length; i++) {
                                        llenarDetalle.add({
                                          "NroLinDet": sum == sum
                                              ? sum = sum + 1
                                              : sum = sum,
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
                })
          ],
        ),
      ),
    );
  }

  void deletePro(int index) {
    setState(() {
      rows.removeAt(index);
    });
  }
}

class ItemFactura {
  int index;
  String description;
  int quantity;
  int amount;
  int totalAmount;

  ItemFactura(this.index, this.description, this.quantity, this.amount,
      this.totalAmount);

  @override
  String toString() {
    return '{ ${this.index}, ${this.description}, ${this.quantity}, ${this.amount}, ${this.totalAmount}}';
  }
}
