import 'package:flutter/material.dart';

class FacturaPage extends StatefulWidget {
  const FacturaPage({Key key}) : super(key: key);

  @override
  _FacturaPageState createState() => _FacturaPageState();
}

class _FacturaPageState extends State<FacturaPage> {
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
                          // Container(
                          //   height: 20,
                          //   width: MediaQuery.of(context).size.width - 8,
                          //   margin: EdgeInsets.all(2),
                          //   color: Colors.blue[100],
                          //   child: Text(
                          //     '${rows[index].index}' +
                          //         ' - ' +
                          //         '${rows[index].description}' +
                          //         ' - ' +
                          //         '${rows[index].quantity}' +
                          //         ' - ' +
                          //         '${rows[index].amount}' +
                          //         ' - ' +
                          //         '${rows[index].totalAmount = rows[index].quantity * rows[index].amount}',
                          //     style: TextStyle(fontSize: 15),
                          //   ),
                          // ),
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
          // Expanded(
          //   child: ListView.builder(
          //       itemCount: 1,
          //       itemBuilder: (BuildContext context, int index) {
          //         return Container(
          //           color: Colors.red,
          //           child: Column(
          //             children: [
          //               Row(
          //                 children: [
          //                   Text('Monto neto total'),
          //                   Text(rows
          //                       .fold(
          //                           0,
          //                           (previousValue, element) =>
          //                               previousValue + element.totalAmount)
          //                       .toString())
          //                 ],
          //               ),
          //               Row(
          //                 children: [
          //                   Text('IVA'),
          //                   Text((rows.fold(
          //                               0,
          //                               (previousValue, element) =>
          //                                   previousValue +
          //                                   element.totalAmount) *
          //                           0.19)
          //                       .toString())
          //                 ],
          //               ),
          //             ],
          //           ),
          //         );
          //       }),
          // )
        ],
      ),
    );
  }

  // Widget _totales() {
  //   for (var i = 0; i < rows.length; i++) {
  //     mntNeto = mntNeto + rows[i].amount;
  //     montoIva = mntNeto * 0.19;
  //     mntTotal = mntNeto = montoIva;
  //     montoPeriodo = mntTotal;
  //     vlrPagar = montoPeriodo;
  //   }

  //   Expanded(
  //       child: ListView.builder(
  //     itemCount: rows.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       return Column(
  //         children: [
  //           Container(
  //             child: Text('Item - Descripción - Cantidad - Precio - Total'),
  //           ),
  //           Container(
  //             height: 200,
  //             margin: EdgeInsets.all(2),
  //             color: Colors.blue[100],
  //             child: Column(
  //               children: [
  //                 Text('Monto Neto: $mntNeto'),
  //                 Text('Monto iva: $montoIva'),
  //                 Text('Monto Total: $mntTotal'),
  //                 Text('Monto Periodo: $montoPeriodo'),
  //                 Text('Valor a pagar: $vlrPagar'),
  //               ],
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   ));
  // }
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
