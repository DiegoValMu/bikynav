// To parse this JSON data, do
//
//     final markers = markersFromJson(jsonString);

import 'dart:convert';

List<Markers> markersFromJson(String str) => List<Markers>.from(json.decode(str).map((x) => Markers.fromJson(x)));

String markersToJson(List<Markers> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Markers {
    String? id;
    String? etiqueta;
    String? contacto;
    String? email;
    String? horario;
    String? website;
    String? descripcion;
    dynamic? fecha;
    String? hora;
    List<String>? imagen;
    List<double>? pos;
    String? usuario;
    int? v;
    String? ciudad;

    Markers({
        this.id,
        this.etiqueta,
        this.contacto,
        this.email,
        this.horario,
        this.website,
        this.descripcion,
        this.fecha,
        this.hora,
        this.imagen,
        this.pos,
        this.usuario,
        this.v,
        this.ciudad,
    });

    factory Markers.fromJson(Map<String, dynamic> json) => Markers(
        id: json["_id"],
        etiqueta: json["etiqueta"],
        contacto: json["contacto"],
        email: json["email"],
        horario: json["horario"],
        website: json["website"],
        descripcion: json["descripcion"],
        fecha: json["fecha"],
        hora: json["hora"],
        imagen: List<String>.from(json["imagen"].map((x) => x)),
        pos: List<double>.from(json["pos"].map((x) => x.toDouble())),
        usuario: json["usuario"],
        v: json["__v"],
        ciudad: json["ciudad"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "etiqueta": etiqueta,
        "contacto": contacto,
        "email": email,
        "horario": horario,
        "website": website,
        "descripcion": descripcion,
        "fecha": fecha,
        "hora": hora,
        "imagen": List<dynamic>.from(imagen!.map((x) => x)),
        "pos": List<dynamic>.from(pos!.map((x) => x)),
        "usuario": usuario,
        "__v": v,
        "ciudad": ciudad,
    };
}
