// To parse this JSON data, do
//
//     final infoModel = infoModelFromJson(jsonString);

import 'dart:convert';

InfoModel infoModelFromJson(String str) => InfoModel.fromJson(json.decode(str));

String infoModelToJson(InfoModel data) => json.encode(data.toJson());

class InfoModel {
  InfoModel({
    this.rut,
    this.razonSocial,
    this.email,
    this.telefono,
    this.direccion,
    this.comuna,
    this.actividades,
    this.sucursales,
  });

  String rut;
  String razonSocial;
  dynamic email;
  dynamic telefono;
  String direccion;
  String comuna;
  List<Actividade> actividades;
  List<Sucursale> sucursales;

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
        rut: json["rut"],
        razonSocial: json["razonSocial"],
        email: json["email"],
        telefono: json["telefono"],
        direccion: json["direccion"],
        comuna: json["comuna"],
        // seriesNo: json["series_no"] != null ? new List<SeriesNo>.from( json["series_no"].map((x) => SeriesNo.fromJson(x))) : List<SeriesNo>().
        actividades: json["actividades"] != null
            ? new List<Actividade>.from(
                json["actividades"].map((x) => Actividade.fromJson(x)))
            : List<Actividade>(),
        sucursales: json["sucursales"] != null
            ? new List<Sucursale>.from(
                json["sucursales"].map((x) => Sucursale.fromJson(x)))
            : List<Sucursale>(),
      );

  Map<String, dynamic> toJson() => {
        "rut": rut,
        "razonSocial": razonSocial,
        "email": email,
        "telefono": telefono,
        "direccion": direccion,
        "comuna": comuna,
        "actividades": List<dynamic>.from(actividades.map((x) => x.toJson())),
        "sucursales": List<dynamic>.from(sucursales.map((x) => x.toJson())),
      };
}

class Actividade {
  Actividade({
    this.giro,
    this.actividadEconomica,
    this.codigoActividadEconomica,
    this.actividadPrincipal,
  });

  String giro;
  String actividadEconomica;
  String codigoActividadEconomica;
  bool actividadPrincipal;

  factory Actividade.fromJson(Map<String, dynamic> json) => Actividade(
        giro: json["giro"],
        actividadEconomica: json["actividadEconomica"],
        codigoActividadEconomica: json["codigoActividadEconomica"],
        actividadPrincipal: json["actividadPrincipal"],
      );

  Map<String, dynamic> toJson() => {
        "giro": giro,
        "actividadEconomica": actividadEconomica,
        "codigoActividadEconomica": codigoActividadEconomica,
        "actividadPrincipal": actividadPrincipal,
      };
}

class Sucursale {
  Sucursale({
    this.cdgSiiSucur,
    this.comuna,
    this.direccion,
    this.ciudad,
    this.telefono,
  });

  String cdgSiiSucur;
  String comuna;
  String direccion;
  String ciudad;
  dynamic telefono;

  factory Sucursale.fromJson(Map<String, dynamic> json) => Sucursale(
        cdgSiiSucur: json["cdgSIISucur"],
        comuna: json["comuna"],
        direccion: json["direccion"],
        ciudad: json["ciudad"],
        telefono: json["telefono"],
      );

  Map<String, dynamic> toJson() => {
        "cdgSIISucur": cdgSiiSucur,
        "comuna": comuna,
        "direccion": direccion,
        "ciudad": ciudad,
        "telefono": telefono,
      };
}
