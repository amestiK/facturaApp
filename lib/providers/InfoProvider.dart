import 'dart:convert';

import 'package:factura/model/boletaModel.dart';
import 'package:factura/model/organizationModel.dart';
import 'package:factura/model/pdfModel.dart';
import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
// import 'dart:io';
import 'package:factura/model/InfoModel.dart';

class InfoProvider {
  final _url = 'https://dev-api.haulmer.com';
  final _apikey = '928e15a2d14d4a6292345f04960f4bd3';
  String _api = FlavorConfig.instance.variables["apiKey"];
  String _url1 = FlavorConfig.instance.variables["baseUrl"];
  PreferenciasUsuario prefs = PreferenciasUsuario();

  Future<InfoModel> cargarInfo(String rut) async {
    final url = '$_url1/v2/dte/taxpayer/$rut';
    //prefs.apikey viene de las variables de preferencias de usuario
    final resp = await http.get(url, headers: {'apikey': prefs.apiKey});

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    InfoModel info = new InfoModel.fromJson(decodedData);

    return info;
  }

  Future<BoletaModel> postBoleta(
      String descripcion, int totNeto, int totIva, int totBruto) async {
    final url = '$_url/v2/dte/document';

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');

    var data = json.encode({
      "response": [
        "XML",
        "PDF",
        "TIMBRE",
        "LOGO",
        "FOLIO",
        "RESOLUCION",
        "80MM"
      ],
      "dte": {
        "Encabezado": {
          "IdDoc": {
            "TipoDTE": 39,
            "Folio": 0,
            "FchEmis": formatter.format(now),
            "IndServicio": "3"
          },
          "Emisor": {
            "RUTEmisor": prefs.rutEmi,
            "RznSocEmisor": prefs.rznEmi,
            "GiroEmisor": prefs.giroEmi,
            "CdgSIISucur": prefs.codEmi,
            "DirOrigen": prefs.dirEmi,
            "CmnaOrigen": prefs.cmaEmi
          },
          "Receptor": {"RUTRecep": "66666666-6"},
          "Totales": {
            "MntNeto": totNeto,
            "IVA": totIva,
            "MntTotal": totBruto,
            "TotalPeriodo": totBruto,
            "VlrPagar": totBruto
          }
        },
        "Detalle": [
          {
            "NroLinDet": 1,
            "NmbItem": descripcion,
            "QtyItem": 1,
            "PrcItem": totBruto,
            "MontoItem": totBruto
          }
        ]
      }
    });
    final resp =
        await http.post(url, headers: {'apikey': prefs.apiKey}, body: data);
    print(resp.body);
    if (resp.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(resp.body);

      BoletaModel bol = new BoletaModel.fromJson(decodedData);
      print(bol.pdf);
      return bol;
    } else {
      return null;
    }
  }

  Future<PdfModel> postInfo(
      String format,
      String rutEmi,
      String rznEmi,
      String giroEmi,
      String actEmi,
      String dirEmi,
      String cmaEmi,
      String codEmi,
      String rutRec,
      String razSocRec,
      String giroRec,
      String dirRec,
      String comRec,
      int totNeto,
      int totIva,
      int totBruto,
      int mntPer,
      int vlrPag,
      List<Map<String, dynamic>> lista) async {
    final url = '$_url/v2/dte/document';

    var idemKey = randomAlphaNumeric(20);
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');

    var data = json.encode({
      "response": ["PDF", "FOLIO", format],
      "dte": {
        "Encabezado": {
          "IdDoc": {
            "TipoDTE": 33,
            "Folio": 0,
            "FchEmis": formatter.format(now),
            "TpoTranCompra": "1",
            "TpoTranVenta": "1",
            "FmaPago": "2"
          },
          "Emisor": {
            "RUTEmisor": rutEmi,
            "RznSoc": rznEmi,
            "GiroEmis": giroEmi,
            "Acteco": actEmi,
            "DirOrigen": dirEmi,
            "CmnaOrigen": cmaEmi,
            "CdgSIISucur": codEmi
          },
          "Receptor": {
            "RUTRecep": rutRec,
            "RznSocRecep": razSocRec,
            "GiroRecep": giroRec,
            "DirRecep": dirRec,
            "CmnaRecep": comRec
          },
          "Totales": {
            "MntNeto": totNeto,
            "TasaIVA": "19",
            "IVA": totIva,
            "MntTotal": totBruto,
            "MontoPeriodo": mntPer,
            "VlrPagar": vlrPag
          }
        },
        "Detalle": lista
      }
    });
    final resp = await http.post(url,
        headers: {
          'apikey': prefs.apiKey,
          'Idempotency-Key': idemKey,
        },
        body: data);
    if (resp.statusCode == 200) {
      print(resp.body);
      final Map<String, dynamic> decodedData = json.decode(resp.body);

      PdfModel pdf = new PdfModel.fromJson(decodedData);
      print(pdf.pdf);

      return pdf;
    } else {
      return null;
    }
  }
}
