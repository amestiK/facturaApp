import 'package:factura/pages/buttons.dart';
import 'package:factura/pages/pdf_page.dart';
import 'package:factura/providers/InfoProvider.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class BoletaPage extends StatefulWidget {
  const BoletaPage({Key key}) : super(key: key);

  @override
  _BoletaPageState createState() => _BoletaPageState();
}

class _BoletaPageState extends State<BoletaPage> {
  InfoProvider infoPro = new InfoProvider();

  String pdfString;

  var userQuestion = '';
  var userAnswer = '';

  final List<String> buttons = [
    'C',
    'DEL',
    '',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    '',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Fondo(plantilla) de la aplicación
        appBar: AppBar(
          //Barra superior
          title: Center(child: Text('Boleta')),
          backgroundColor: Colors.deepPurple,
          elevation: 4.0,
        ),
        body: Column(
          //Cuerpo de la app
          //Se crea una columna en el body
          children: [
            //EXPRESION Y RESULTADO
            Expanded(
              //Utilizamos todo el espacio del container
              child: Container(
                color: Colors.deepPurple[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child:
                            Text(userQuestion, style: TextStyle(fontSize: 25))),
                    Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.centerRight,
                      child: Text(
                        userAnswer,
                        style: TextStyle(fontSize: 35),
                      ),
                    ),
                  ],
                ),
              ), //Contenedor que se usara para los resultados.
            ),
            //BOTONES
            Expanded(
              flex: 3, //Se especifica que se ocupe 2/3 de la columna expandida.
              child: Container(
                color: Colors.deepPurple[100],
                child: Center(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: buttons.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, childAspectRatio: 1.6),
                    itemBuilder: (BuildContext context, int index) {
                      //Boton C = Clear
                      if (index == 0) {
                        return MyButton(
                          buttonTapped: () {
                            setState(() {
                              userQuestion = '';
                              userAnswer = '';
                            });
                          },
                          buttonText: buttons[index],
                          color: Colors.green,
                          textColor: Colors.white,
                          textsize: 30.0,
                        );
                      }
                      //Boton DEL = Delete
                      else if (index == 1) {
                        return MyButton(
                          buttonTapped: () {
                            setState(() {
                              // Desde la posicion 0 (primer valor) segun userQuestion.length (largo total) extraer 1.
                              userQuestion = userQuestion.substring(
                                  0, userQuestion.length - 1);
                              if (userQuestion == "") {
                                userQuestion = '';
                              }
                            });
                          },
                          buttonText: buttons[index],
                          color: Colors.red,
                          textColor: Colors.white,
                          textsize: 30.0,
                        );
                        // Boton = Resultado
                      } else if (index == buttons.length - 1) {
                        return MyButton(
                          buttonTapped: () {
                            setState(() {
                              //Referencia al metodo math_expressions.
                              equalPressed();
                              userQuestion = userAnswer;
                            });
                          },
                          buttonText: buttons[index],
                          color: Colors.red,
                          textColor: Colors.white,
                          textsize: 30.0,
                        );
                        //Los demas botones
                      } else
                        return MyButton(
                          buttonTapped: () {
                            setState(() {
                              // userQuestion = userQuestion + buttons[index];
                              userQuestion += buttons[index];
                            });
                          },
                          buttonText: buttons[index],
                          color: isOperator(buttons[index])
                              ? Colors.deepPurple
                              : Colors.white,
                          textColor: isOperator(buttons[index])
                              ? Colors.white
                              : Colors.deepPurple,
                          textsize: 30.0,
                        );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(8),
                color: Colors.deepPurple[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                        child: Text('Enviar'),
                        textColor: Colors.white,
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200.0)),
                        onPressed: () async {
                          await infoPro
                              .postBoleta()
                              .then((value) => pdfString = value.pdf);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PdfPage(
                                    pdfString: pdfString,
                                  )));
                        }),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('x', '*');
    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    userAnswer = eval.toString();
  }
}
