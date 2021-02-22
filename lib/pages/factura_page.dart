import 'package:factura/model/pdfModel.dart';
import 'package:factura/pages/pdf_page.dart';
import 'package:factura/providers/InfoProvider.dart';
import 'package:flutter/material.dart';

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
  PdfModel pdfModel = new PdfModel();

  InfoProvider info = InfoProvider();

  final List<ItemFactura> rows = [];
  final List<Map<String, dynamic>> llenarDetalle = [];

  final _formKey = GlobalKey<FormState>();

  TextEditingController desCon = TextEditingController();
  TextEditingController quanCon = TextEditingController();
  TextEditingController amouCon = TextEditingController();
  TextEditingController totCon = TextEditingController();

  //Producto
  int montoTotalPro = 0;
  int quantity = 0;
  int amount = 0;
  int sum = 0;
  //
  String pdfString;

  void addItemToList() {
    setState(() {
      rows.insert(
          0,
          ItemFactura(rows.length, desCon.text, int.parse(quanCon.text),
              int.parse(amouCon.text), montoTotalPro));
    });
  }

  @override
  Widget build(BuildContext context) {
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
                keyboardType: TextInputType.text,
                controller: desCon,
                decoration: InputDecoration(
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
                keyboardType: TextInputType.number,
                controller: quanCon,
                decoration: InputDecoration(
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
                keyboardType: TextInputType.number,
                controller: amouCon,
                decoration: InputDecoration(
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
                if (_formKey.currentState.validate()) {
                  String desc = desCon.text.toString();
                  int qty = int.parse(quanCon.text.toString());
                  int amou = int.parse(amouCon.text.toString());
                  int mont = qty * amou;

                  llenarDetalle.add({
                    "NroLinDet": sum == sum ? sum = sum + 1 : sum = sum,
                    "NmbItem": desc,
                    "QtyItem": qty,
                    "PrcItem": amou,
                    "MontoItem": mont
                  });
                  addItemToList();
                  print(llenarDetalle.toList());
                  desCon.clear();
                  quanCon.clear();
                  amouCon.clear();
                }
              },
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
                                      Text(element.index.toString()),
                                    ),
                                    DataCell(
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              rows.removeAt(index);
                                              llenarDetalle.removeAt(index);
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
                                  ///ToDo: Calculate the total price for all items
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
                                  ///ToDo: Calculate the total price for all items
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
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Confirmación'),
                            content: Text(
                                '¿Estás seguro que deseas emitir esta factura?'),
                            actions: [
                              FlatButton(
                                  onPressed: () async {
                                    int totAmou = int.parse(rows
                                        .fold(
                                            0,
                                            (prev, el) =>
                                                prev + el.amount * el.quantity)
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

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => PdfPage(
                                                  pdfString: pdfString,
                                                )));
                                  },
                                  child: Text('Confirmar')),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancelar'))
                            ],
                          ));
                })
          ],
        ),
      ),
    );
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
