import 'package:flutter/material.dart';

class FacturaPage extends StatelessWidget {
  const FacturaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Factura')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Text('Pag Factura'),
            ),
          )
        ],
      ),
    );
  }
}
