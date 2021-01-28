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
  InfoProvider info = InfoProvider();

  final List<ItemFactura> rows = <ItemFactura>[];

  TextEditingController desCon = TextEditingController();
  TextEditingController quanCon = TextEditingController();
  TextEditingController amouCon = TextEditingController();
  TextEditingController totCon = TextEditingController();

  //Producto
  double montoTotalPro = 0;

  void addItemToList() {
    setState(() {
      rows.insert(
          0,
          ItemFactura(rows.length, desCon.text, int.parse(quanCon.text),
              double.parse(amouCon.text), montoTotalPro));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Detalle factura')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: desCon,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Descripción',
            ),
          ),
          TextField(
            controller: quanCon,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Cantidad',
            ),
          ),
          TextField(
            controller: amouCon,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Monto',
            ),
          ),
          RaisedButton(
            child: Text('Agregar'),
            onPressed: () {
              addItemToList();
              print(widget.rutRec);
              print(widget.giroRec);
              print(rows.toList());
            },
          ),
          Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        rows.removeAt(index);
                      });
                    },
                    child: SingleChildScrollView(
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
                                      Text(element.description.toString()),
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
                    ),
                  );
                },
              )),
          RaisedButton(onPressed: () {
            info.postInfo(widget.rutRec, widget.razSocRec, widget.giroRec,
                widget.dirRec, widget.comRec);
          })
        ],
      ),
    );
  }
}

class ItemFactura {
  int index;
  String description;
  int quantity;
  double amount;
  double totalAmount;

  ItemFactura(this.index, this.description, this.quantity, this.amount,
      this.totalAmount);

  @override
  String toString() {
    return '{ ${this.index}, ${this.description}, ${this.quantity}, ${this.amount}, ${this.totalAmount}}';
  }
}
