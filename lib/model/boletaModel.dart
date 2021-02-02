// To parse this JSON data, do
//
//     final boletaModel = boletaModelFromJson(jsonString);

import 'dart:convert';

BoletaModel boletaModelFromJson(String str) =>
    BoletaModel.fromJson(json.decode(str));

String boletaModelToJson(BoletaModel data) => json.encode(data.toJson());

class BoletaModel {
  BoletaModel({
    this.token,
    this.folio,
    this.resolucion,
    this.timbre,
    this.xml,
    this.logo,
    this.pdf,
  });

  String token;
  int folio;
  Resolucion resolucion;
  String timbre;
  String xml;
  String logo;
  String pdf;

  factory BoletaModel.fromJson(Map<String, dynamic> json) => BoletaModel(
        token: json["TOKEN"],
        folio: json["FOLIO"],
        resolucion: Resolucion.fromJson(json["RESOLUCION"]),
        timbre: json["TIMBRE"],
        xml: json["XML"],
        logo: json["LOGO"],
        pdf: json["PDF"],
      );

  Map<String, dynamic> toJson() => {
        "TOKEN": token,
        "FOLIO": folio,
        "RESOLUCION": resolucion.toJson(),
        "TIMBRE": timbre,
        "XML": xml,
        "LOGO": logo,
        "PDF": pdf,
      };
}

class Resolucion {
  Resolucion({
    this.fecha,
    this.numero,
  });

  DateTime fecha;
  int numero;

  factory Resolucion.fromJson(Map<String, dynamic> json) => Resolucion(
        fecha: DateTime.parse(json["fecha"]),
        numero: json["numero"],
      );

  Map<String, dynamic> toJson() => {
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "numero": numero,
      };
}
