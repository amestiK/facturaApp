import 'package:factura/pages/home_page.dart';

import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:printing/printing.dart';
// import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class PdfPage extends StatefulWidget {
  final String pdfString;

  const PdfPage({Key key, this.pdfString}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PdfPage> {
  //Variables para el uso del BottomBar
  int _currentIndex = 0;
  String btn2;
  // PDF
  bool _isLoading = true;
  // PDFDocument document;
  final DateFormat formatter = DateFormat('ddMMyyyyHHmmss');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        // leading: IconButton(
        //     alignment: Alignment.centerLeft,
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.pushAndRemoveUntil(
        //           context,
        //           MaterialPageRoute(builder: (context) => Home()),
        //           (Route<dynamic> route) => false);
        //     }),
        title: Center(child: Text('PDF')),
      ), //Boton flotante
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 5,
            child: FloatingActionButton(
              backgroundColor: Colors.purple,
              heroTag: btn2,
              child: Icon(Icons.print),
              onPressed: () async {
                // var printPdf = await writePDF(widget.pdfString);
                // await FlutterPdfPrinter.printFileFromBytes(
                //     printPdf.readAsStringSync());

                var printPdf = await writePDF(widget.pdfString);

                var info = await Printing.info();

                // final printers = await Printing.listPrinters();

                print(info);

                // await Printing.directPrintPdf(
                //     printer: printers.first,
                //     onLayout: (_) => printPdf.readAsBytesSync());

                await Printing.layoutPdf(
                    onLayout: (_) => printPdf.readAsBytesSync());
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 5,
            child: FloatingActionButton(
              backgroundColor: Colors.purple,
              heroTag: btn2,
              child: Icon(Icons.share),
              onPressed: () {
                onTabTapped(0);
              },
            ),
          ),
        ],
      ),

      /*bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped, // Botón clicado
          currentIndex: 1, // Indice de botón clicado
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
        ),*/
      // body: Column(
      //   children: [
      //     Expanded(
      //         flex: 6,
      //         child: _isLoading
      //             ? Center(child: CircularProgressIndicator())
      //             : PDFViewer(document: document)),
      //   ],
      // ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadDocument(widget.pdfString);
  }

  loadDocument(pdfString) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    final filename = "default.pdf";
    File file = new File('$dir/$filename');
    debugPrint(file.path);
    // document = await PDFDocument.fromFile(await writePDF(pdfString));

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
      writePDF(widget.pdfString);
      await loadDocument(widget.pdfString);
    } else {
      // document = await PDFDocument.fromFile(await writePDF(widget.pdfString));
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
