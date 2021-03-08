import 'package:factura/bloc/provider.dart';
import 'package:factura/pages/utils.dart';
import 'package:factura/providers/usuario_provider.dart';
import 'package:flutter/material.dart';

class RecuperarPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      _crearFondo(context),
      _loginForm(context),
    ]));
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0,
                  )
                ]),
            child: Column(children: <Widget>[
              Text('Ingreso', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 60.0),
              _crearEmail(bloc),
              _crearBoton2(bloc),
            ]),
          ),
          FlatButton(
            child: Text('Crear una nueva cuenta'),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'registro'),
          ),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo electronico',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _crearBoton2(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                child: Text('Cambio Clave')),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 0.0,
            color: Colors.deepPurple,
            textColor: Colors.white,
            onPressed: snapshot.hasData ? () => _login2(bloc, context) : null);
      },
    );
  }

  _login2(LoginBloc bloc, BuildContext context) async {
    Map info = await usuarioProvider.cambioClave(bloc.email);
    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'login');
    } else {
      mostrarAlerta(context, info['mensaje']);
    }
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0),
      ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(
          top: 90.0,
          left: 30.0,
          child: circulo,
        ),
        Positioned(
          top: -40.0,
          right: -30.0,
          child: circulo,
        ),
        Positioned(
          bottom: -50.0,
          right: -10.0,
          child: circulo,
        ),
        Positioned(
          bottom: 120.0,
          right: 20.0,
          child: circulo,
        ),
        Positioned(
          top: 210.0,
          left: -20.0,
          child: circulo,
        ),
        Container(
            padding: EdgeInsets.only(top: 80.0),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.person_pin_circle,
                  color: Colors.white,
                  size: 100.0,
                ),
                SizedBox(height: 10.0, width: double.infinity),
                Text('Nombre',
                    style: TextStyle(color: Colors.white, fontSize: 25.0))
              ],
            ))
      ],
    );
  }
}
