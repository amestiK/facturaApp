import 'package:factura/model/registryModel.dart';
import 'package:factura/pages/pdf_page.dart';
import 'package:factura/providers/organizationProvider.dart';
import 'package:flutter/material.dart';

class HisPage extends StatefulWidget {
  HisPage({Key key}) : super(key: key);

  @override
  _HisPageState createState() => _HisPageState();
}

class _HisPageState extends State<HisPage> {
  OrgProvider orgInfo = OrgProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Historial')),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder(
        future: orgInfo.cargarReg(),
        builder: (BuildContext context, AsyncSnapshot<RegistryModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return _ListaRegistros(snapshot.data.data);
          }
        },
      ),
    );
  }
}

class _ListaRegistros extends StatelessWidget {
  final List<Datum> registros;

  _ListaRegistros(this.registros);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: registros.length,
      itemBuilder: (BuildContext context, int i) {
        final registro = registros[i];

        return ListTile(
          title: Text(
              '${registro.rznSocRecep.toString().replaceAll("_", " ").substring(12, registro.rznSocRecep.toString().length)} ${registro.rutRecep}-${registro.dv}'),
          subtitle:
              Text('DTE: ${registro.tipoDte} Total: ${registro.mntTotal}'),
          trailing: IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              String codDte = registro.tipoDte.toString();
              String folio = registro.folio.toString();
              String pdfString;

              OrgProvider orgInfo = OrgProvider();

              await orgInfo.cargarDte(codDte, folio).then((value) {
                pdfString = value.pdf;
              });

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PdfPage(
                        pdfString: pdfString,
                      )));
            },
          ),
        );
      },
    );
  }
}
