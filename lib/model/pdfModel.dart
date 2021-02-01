// To parse this JSON data, do
//
//     final pdfModel = pdfModelFromJson(jsonString);

import 'dart:convert';

PdfModel pdfModelFromJson(String str) => PdfModel.fromJson(json.decode(str));

String pdfModelToJson(PdfModel data) => json.encode(data.toJson());

class PdfModel {
  PdfModel({
    this.token,
    this.folio,
    this.pdf,
  });

  String token;
  int folio;
  String pdf;

  factory PdfModel.fromJson(Map<String, dynamic> json) => PdfModel(
        token: json["TOKEN"],
        folio: json["FOLIO"],
        pdf: json["PDF"],
      );

  Map<String, dynamic> toJson() => {
        "TOKEN": token,
        "FOLIO": folio,
        "PDF": pdf,
      };
}
