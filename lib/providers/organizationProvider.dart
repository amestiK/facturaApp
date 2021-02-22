import 'dart:convert';
import 'package:factura/model/docModel.dart';
import 'package:http/http.dart' as http;
// import 'dart:io';
import 'package:factura/model/organizationModel.dart';
import 'package:factura/model/registryModel.dart';

class OrgProvider {
  final _url = 'https://dev-api.haulmer.com';
  final _apikey = '928e15a2d14d4a6292345f04960f4bd3';

  Future<OrganizationModel> cargarOrg() async {
    final url = '$_url/v2/dte/organization';

    final resp = await http.get(url, headers: {'apikey': _apikey});

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    OrganizationModel infoOrg = new OrganizationModel.fromJson(decodedData);

    return infoOrg;
  }

  Future<RegistryModel> cargarReg() async {
    final url = '$_url/v2/dte/document/issued';

    var data = json.encode({
      "Page": "5",
      "TipoDTE": {"eq": "33"},
      "FchEmis": {"lte": "2019-01-31", "gte": "2018-12-01"}
    });

    final resp = await http.post(url,
        headers: {
          'apikey': _apikey,
        },
        body: data);
    if (resp.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      print(resp.body);
      RegistryModel regModel = new RegistryModel.fromJson(decodedData);
      print(regModel);

      return regModel;
    } else {
      return null;
    }
  }

  Future<DocModel> cargarDte(String dte, String folio) async {
    final url = '$_url/v2/dte/document/76795561-8/$dte/$folio/pdf';

    final resp = await http.get(url, headers: {'apikey': _apikey});

    if (resp.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      DocModel pdf = new DocModel.fromJson(decodedData);
      return pdf;
    } else {
      return null;
    }
  }
}
