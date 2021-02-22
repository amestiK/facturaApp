// To parse this JSON data, do
//
//     final docModel = docModelFromJson(jsonString);

import 'dart:convert';

DocModel docModelFromJson(String str) => DocModel.fromJson(json.decode(str));

String docModelToJson(DocModel data) => json.encode(data.toJson());

class DocModel {
  DocModel({
    this.pdf,
    this.folio,
  });

  String pdf;
  String folio;

  factory DocModel.fromJson(Map<String, dynamic> json) => DocModel(
        pdf: json["pdf"],
        folio: json["folio"],
      );

  Map<String, dynamic> toJson() => {
        "pdf": pdf,
        "folio": folio,
      };
}
