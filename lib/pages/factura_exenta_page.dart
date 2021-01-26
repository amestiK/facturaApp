import 'package:flutter/material.dart';

class FacExePage extends StatelessWidget {
  const FacExePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Factura exenta')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Text('Pag Factura exenta'),
            ),
          )
        ],
      ),
    );
  }
}
