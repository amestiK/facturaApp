import 'dart:convert';
import 'package:factura/model/boletaModel.dart';
import 'package:factura/model/pdfModel.dart';
import 'package:http/http.dart' as http;
// import 'dart:io';
import 'package:factura/model/InfoModel.dart';

class InfoProvider {
  final _url = 'https://dev-api.haulmer.com';
  final _apikey = '928e15a2d14d4a6292345f04960f4bd3';

  Future<InfoModel> cargarInfo(String rut) async {
    final url = '$_url/v2/dte/taxpayer/$rut';

    final resp = await http.get(url, headers: {'apikey': _apikey});

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    InfoModel info = new InfoModel.fromJson(decodedData);

    return info;
  }

  Future<BoletaModel> postBoleta(
      String descripcion, int totNeto, int totIva, int totBruto) async {
    final url = '$_url/v2/dte/document';

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
            "FchEmis": "2020-11-25",
            "IndServicio": "3"
          },
          "Emisor": {
            "RUTEmisor": "76795561-8",
            "RznSocEmisor": "HAULMERSPA",
            "GiroEmisor":
                "VENTA AL POR MENOR EN EMPRESAS DE VENTA A DISTANCIA VÍA INTERNET",
            "CdgSIISucur": "81303347",
            "DirOrigen": "ARTURO PRAT 527 CURICO",
            "CmnaOrigen": "Curicó"
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
    final resp = await http.post(url, headers: {'apikey': _apikey}, body: data);
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
      "response": ["PDF", "FOLIO", "80MM"],
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
          'apikey': _apikey,
          'Idempotency-Key': 'lkmmmm',
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
