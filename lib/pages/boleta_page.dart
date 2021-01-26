import 'package:flutter/material.dart';

class BoletaPage extends StatelessWidget {
  const BoletaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Boleta')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Text('Pag Boleta'),
            ),
          )
        ],
      ),
    );
  }
}
