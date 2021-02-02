import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  //variables para asignar propiedades de los botones.
  final color;
  final textColor;
  final String buttonText;
  final buttonTapped;
  final textsize;

  // Constructor con parametros del widget(class) de botones.
  MyButton(
      {this.color,
      this.textColor,
      this.buttonText,
      this.textsize,
      this.buttonTapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //Este widget nos permite detectar las texturas para utilizarlas como boton.
      onTap: buttonTapped,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: color,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(color: textColor, fontSize: textsize),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
