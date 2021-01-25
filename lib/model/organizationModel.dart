// To parse this JSON data, do
//
//     final organizationModel = organizationModelFromJson(jsonString);

import 'dart:convert';

OrganizationModel organizationModelFromJson(String str) =>
    OrganizationModel.fromJson(json.decode(str));

String organizationModelToJson(OrganizationModel data) =>
    json.encode(data.toJson());

class OrganizationModel {
  OrganizationModel({
    this.rut,
    this.razonSocial,
    this.email,
    this.telefono,
    this.direccion,
    this.cdgSiiSucur,
    this.glosaDescriptiva,
    this.direccionRegional,
    this.comuna,
    this.resolucion,
    this.nombreFantasia,
    this.web,
    this.sucursales,
    this.actividades,
  });

  String rut;
  String razonSocial;
  String email;
  String telefono;
  String direccion;
  String cdgSiiSucur;
  String glosaDescriptiva;
  String direccionRegional;
  String comuna;
  Resolucion resolucion;
  String nombreFantasia;
  String web;
  List<dynamic> sucursales;
  List<Actividade> actividades;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      OrganizationModel(
        rut: json["rut"],
        razonSocial: json["razonSocial"],
        email: json["email"],
        telefono: json["telefono"],
        direccion: json["direccion"],
        cdgSiiSucur: json["cdgSIISucur"],
        glosaDescriptiva: json["glosaDescriptiva"],
        direccionRegional: json["direccionRegional"],
        comuna: json["comuna"],
        resolucion: Resolucion.fromJson(json["resolucion"]),
        nombreFantasia: json["nombreFantasia"],
        web: json["web"],
        sucursales: List<dynamic>.from(json["sucursales"].map((x) => x)),
        actividades: List<Actividade>.from(
            json["actividades"].map((x) => Actividade.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rut": rut,
        "razonSocial": razonSocial,
        "email": email,
        "telefono": telefono,
        "direccion": direccion,
        "cdgSIISucur": cdgSiiSucur,
        "glosaDescriptiva": glosaDescriptiva,
        "direccionRegional": direccionRegional,
        "comuna": comuna,
        "resolucion": resolucion.toJson(),
        "nombreFantasia": nombreFantasia,
        "web": web,
        "sucursales": List<dynamic>.from(sucursales.map((x) => x)),
        "actividades": List<dynamic>.from(actividades.map((x) => x.toJson())),
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

class Resolucion {
  Resolucion({
    this.fecha,
    this.numero,
  });

  DateTime fecha;
  String numero;

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
