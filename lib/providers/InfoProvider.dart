import 'dart:convert';
import 'package:factura/model/pdfModel.dart';
import 'package:factura/share_prefs/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
// import 'dart:io';
import 'package:factura/model/InfoModel.dart';

class InfoProvider {
  final pref = new PreferenciasUsuario();
  final _url = 'https://dev-api.haulmer.com';
  String _apikey = '928e15a2d14d4a6292345f04960f4bd3';

  Future<InfoModel> cargarInfo(String rut) async {
    final url = '$_url/v2/dte/taxpayer/$rut';

    final resp = await http.get(url, headers: {'apikey': '${pref.apiKey}'});

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    InfoModel info = new InfoModel.fromJson(decodedData);

    return info;
  }

  Future<Pdf> postInfo(
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

    var data = json.encode({
      "response": ["PDF", "FOLIO"],
      "dte": {
        "Encabezado": {
          "IdDoc": {
            "TipoDTE": 33,
            "Folio": 0,
            "FchEmis": "2019-04-08",
            "TpoTranCompra": "1",
            "TpoTranVenta": "1",
            "FmaPago": "2"
          },
          "Emisor": {
            "RUTEmisor": "76795561-8",
            "RznSoc": "HAULMER SPA",
            "GiroEmis": "VENTAALPORMENORPORCORREO,PORINTERNETYVIATELEFONICA",
            "Acteco": "479100",
            "DirOrigen": "ARTUROPRAT527CURICO",
            "CmnaOrigen": "Curicó",
            "Telefono": "00",
            "CdgSIISucur": "81303347"
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
          'apikey': pref.apiKey,
          'Idempotency-Key': 'fffffdddd',
        },
        body: data);
    if (resp.statusCode == 200) {
      print(resp.body);
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      Pdf pdf = new Pdf.fromJson(decodedData);
      print('-----------------------------------------');
      print(pdf.pdf);

      return pdf;
    } else {
      return null;
    }
  }
}
