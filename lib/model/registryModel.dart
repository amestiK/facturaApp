// To parse this JSON data, do
//
//     final registryModel = registryModelFromJson(jsonString);

import 'dart:convert';

RegistryModel registryModelFromJson(String str) =>
    RegistryModel.fromJson(json.decode(str));

String registryModelToJson(RegistryModel data) => json.encode(data.toJson());

class RegistryModel {
  RegistryModel({
    this.currentPage,
    this.lastPage,
    this.data,
    this.total,
  });

  int currentPage;
  int lastPage;
  List<Datum> data;
  int total;

  factory RegistryModel.fromJson(Map<String, dynamic> json) => RegistryModel(
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "last_page": lastPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total": total,
      };
}

class Datum {
  Datum({
    this.rutRecep,
    this.dv,
    this.rznSocRecep,
    this.tipoDte,
    this.folio,
    this.fchEmis,
    this.fechaRecibido,
    this.mntExe,
    this.mntNeto,
    this.iva,
    this.mntTotal,
    this.fmaPago,
    this.token,
  });

  int rutRecep;
  String dv;
  RznSocRecep rznSocRecep;
  int tipoDte;
  int folio;
  DateTime fchEmis;
  DateTime fechaRecibido;
  int mntExe;
  int mntNeto;
  int iva;
  int mntTotal;
  int fmaPago;
  String token;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        rutRecep: json["RUTRecep"],
        dv: json["DV"],
        rznSocRecep: rznSocRecepValues.map[json["RznSocRecep"]],
        tipoDte: json["TipoDTE"],
        folio: json["Folio"],
        fchEmis: DateTime.parse(json["FchEmis"]),
        fechaRecibido: DateTime.parse(json["FechaRecibido"]),
        mntExe: json["MntExe"],
        mntNeto: json["MntNeto"],
        iva: json["IVA"],
        mntTotal: json["MntTotal"],
        fmaPago: json["FmaPago"],
        token: json["Token"],
      );

  Map<String, dynamic> toJson() => {
        "RUTRecep": rutRecep,
        "DV": dv,
        "RznSocRecep": rznSocRecepValues.reverse[rznSocRecep],
        "TipoDTE": tipoDte,
        "Folio": folio,
        "FchEmis":
            "${fchEmis.year.toString().padLeft(4, '0')}-${fchEmis.month.toString().padLeft(2, '0')}-${fchEmis.day.toString().padLeft(2, '0')}",
        "FechaRecibido": fechaRecibido.toIso8601String(),
        "MntExe": mntExe,
        "MntNeto": mntNeto,
        "IVA": iva,
        "MntTotal": mntTotal,
        "FmaPago": fmaPago,
        "Token": token,
      };
}

enum RznSocRecep { HOSTY_SPA, COMERCIALIZADORA_BANDEL_SUR_LIMITADA }

final rznSocRecepValues = EnumValues({
  "COMERCIALIZADORA BANDEL SUR LIMITADA":
      RznSocRecep.COMERCIALIZADORA_BANDEL_SUR_LIMITADA,
  "HOSTY SPA": RznSocRecep.HOSTY_SPA
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
