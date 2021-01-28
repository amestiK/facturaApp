import 'dart:convert';

Pdf pdfFromJson(String str) => Pdf.fromJson(json.decode(str));

String pdfToJson(Pdf data) => json.encode(data.toJson());

class Pdf {
  Pdf({
    this.token,
    this.folio,
    this.pdf,
  });

  String token;
  int folio;
  String pdf;

  factory Pdf.fromJson(Map<String, dynamic> json) => Pdf(
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
