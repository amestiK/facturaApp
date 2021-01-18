import 'dart:convert';
// import 'dart:io';
import 'package:factura/model/InfoModel.dart';
import 'package:http/http.dart' as http;

class InfoProvider {
  final _url = 'https://dev-api.haulmer.com';
  final _apikey = '41eb78998d444dbaa4922c410ef14057';

  Future<InfoModel> cargarInfo(String rut) async {
    final url = '$_url/v2/dte/taxpayer/$rut';

    final resp = await http.get(url, headers: {'apikey': _apikey});

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    InfoModel info = new InfoModel.fromJson(decodedData);

    return info;
  }
}
