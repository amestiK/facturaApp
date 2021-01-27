import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'dart:io';
import 'package:factura/model/organizationModel.dart';

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
}
