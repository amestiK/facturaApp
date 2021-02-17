import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
// PDF
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// prueba de atualización de archivo
///
class PdfPage extends StatefulWidget {
  final String pdfString;

  const PdfPage({Key key, this.pdfString}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PdfPage> {
  //Variables para el uso del BottomBar
  int _currentIndex = 0;

  // PDF
  bool _isLoading = true;
  PDFDocument document;
  final DateFormat formatter = DateFormat('ddMMyyyyHHmmss');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Center(child: Text('PDF')),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped, // Botón clicado
          currentIndex: _currentIndex, // Indice de botón clicado
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.share),
              label: 'Compartir',
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.create),
              label: 'Crear PDF',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.picture_as_pdf), label: 'Mostrar PDF creado')
          ],
        ),
        body: Column(
          children: [
            Expanded(
                flex: 6,
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : PDFViewer(document: document)),
            /*
            Expanded(
              flex: 0,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  ListTile(
                    title: Text('Cargar pdf desde url'),
                    onTap: () {
                      changePDF(0);
                    },
                  ),
                ],
              ),
            ),
            */
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    loadDocument(widget.pdfString);
    // loadDocument();
  }

  loadDocument(pdfString) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    final filename = "default.pdf";
    File file = new File('$dir/$filename');
    debugPrint(file.path);
    document = await PDFDocument.fromFile(await writePDF(pdfString));

    setState(() => _isLoading = false);
  }

// PDF
  changePDF(value) async {
    setState(() => _isLoading = true);
    if (value == 0) {
      var sharePdf = await writePDF(widget.pdfString);

      String nameFile = formatter.format(DateTime.now());
      print(nameFile);

      await Share.file(
          'Documento PDF', '$nameFile.pdf', sharePdf.readAsBytesSync(), '*/*');
    } else if (value == 1) {
      //document = await PDFDocument.fromAsset('assets/sample2.pdf');
      writePDF(widget.pdfString);
      await loadDocument(widget.pdfString);
    } else {
      //File file  = File('...');
      //document = await PDFDocument.fromFile(file);
      document = await PDFDocument.fromFile(await writePDF(widget.pdfString));
    }
    setState(() => _isLoading = false);
  }

// Botón clicado
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      changePDF(index);
    });
  }

// Escribe archivo PDF de String codificado (Base64)
  Future<File> writePDF(String pdfFile) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    final filename = "pdfEjemplo.pdf";
    final decodedBytes = base64Decode(pdfFile);
    File file = new File('$dir/$filename');
    await file.writeAsBytes(decodedBytes.buffer.asUint8List());
    debugPrint(file.path);
    return file;
  }
}
