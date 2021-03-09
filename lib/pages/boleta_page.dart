import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:factura/pages/buttons.dart';
import 'package:factura/pages/pdf_page.dart';
import 'package:factura/providers/InfoProvider.dart';
import 'package:factura/Constantsboleta.dart';
import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

class BoletaPage extends StatefulWidget {
  @override
  _BoletaPageState createState() => _BoletaPageState();
}

class _BoletaPageState extends State<BoletaPage> {
  @override
  void initState() {
    super.initState();
    //pref.descripcion = desCon.text;
  }

  ArsProgressDialog _progressDialog;

  InfoProvider infoPro = new InfoProvider();

  final _formKey = GlobalKey<FormState>();

  TextEditingController desCon = TextEditingController();

  bool isLoading = false;
  final pref = new PreferenciasUsuario();

  String desc;
  int totNeto;
  int totIva;
  int totBruto;

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
    _progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    return Scaffold(
        resizeToAvoidBottomInset: true,
        //Fondo(plantilla) de la aplicación
        appBar: AppBar(
          //Barra superior
          title: Center(child: Text('Boleta')),
          backgroundColor: Colors.deepPurple,
          elevation: 4.0,
          actions: [
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return ConstantsBoleta.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Column(
          //Cuerpo de la app
          //Se crea una columna en el body
          children: [
            //EXPRESION Y RESULTADO
            Expanded(
              flex: 2,
              //Utilizamos todo el espacio del container
              child: Container(
                color: Colors.deepPurple[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        padding: EdgeInsets.all(1),
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
                    itemCount: buttons.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, childAspectRatio: 1.9),
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
                              var f = NumberFormat('###,###');
                              int numerInt = double.parse(userAnswer).floor();
                              String numFor = f.format(numerInt);
                              userAnswer = numFor;
                              print(userAnswer);
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
              child: Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8),
                  color: Colors.deepPurple[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Descripción boleta: ${pref.descripcion}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0),
                      ),
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : RaisedButton(
                              child: Text('Enviar'),
                              textColor: Colors.white,
                              color: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(200.0)),
                              onPressed: () async {
                                double value = userAnswer == ''
                                    ? 0
                                    : double.parse(
                                            userAnswer.replaceAll(',', '')) /
                                        1.19;
                                print(value);
                                totNeto = value.round();
                                double value2 = totNeto * 0.19;
                                totIva = value2.round();
                                totBruto = totNeto + totIva;
                                pref.descripcion = pref.descripcion.toString();

                                if (userAnswer != '' &&
                                    pref.descripcion != '' &&
                                    totBruto < 1000000) {
                                  _progressDialog.show();

                                  await infoPro
                                      .postBoleta(pref.descripcion, totNeto,
                                          totIva, totBruto)
                                      .then((value) => pdfString = value.pdf);

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PdfPage(
                                            pdfString: pdfString,
                                          )));
                                  desCon.clear();
                                  userQuestion = '';
                                  userAnswer = '';
                                } else if (userAnswer == '' ||
                                    userAnswer == null) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('Alerta'),
                                            content: Text(
                                                'Debe ingresar un monto para la boleta'),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Ok'))
                                            ],
                                          ));
                                } else if (totBruto >= 1000000 &&
                                    totBruto < 10000000) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('Alerta'),
                                            content: Text(
                                                '¿Estas seguro que deseas emitir una boleta de $totBruto ?'),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () async {
                                                    _progressDialog.show();

                                                    await infoPro
                                                        .postBoleta(
                                                            pref.descripcion,
                                                            totNeto,
                                                            totIva,
                                                            totBruto)
                                                        .then((value) =>
                                                            pdfString =
                                                                value.pdf);

                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    PdfPage(
                                                                      pdfString:
                                                                          pdfString,
                                                                    )));
                                                    desCon.clear();
                                                    userQuestion = '';
                                                    userAnswer = '';
                                                  },
                                                  child: Text('Confirmar')),
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Cancelar'))
                                            ],
                                          ));
                                } else if (totBruto >= 10000000) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('Alerta'),
                                            content: Text(
                                                'El monto de una Boleta no puede exceder a 10.000.000'),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Ok'))
                                            ],
                                          ));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('Alerta'),
                                            content: Text(
                                                'Debe ingresar una descripción a la boleta, dirigirse a Configuración para establecer un valor'),
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
                    ],
                  ),
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
    finalQuestion = finalQuestion.replaceAll(',', '');
    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    userAnswer = eval.toString();
  }

  void choiceAction(String choice) {
    if (choice == ConstantsBoleta.SettingsPage) {
      // Navigator.pushNamed(context, 'FacturaPage');
      Navigator.pushNamed(context, 'Preferencias');
    }
  }
}
