// To parse this JSON data, do
//
//     final bikes = bikesFromJson(jsonString);

import 'dart:convert';

List<Bikes> bikesFromJson(String str) => List<Bikes>.from(json.decode(str).map((x) => Bikes.fromJson(x)));

String bikesToJson(List<Bikes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bikes {
    String? id;
    String? etiqueta;
    String? marca;
    String? modelo;
    String? codigoSerie;
    String? colorPrincipal;
    String? tipo;
    String? aro;
    String? modeloCuadro;
    String? talla;
    List<String>? imagen;
    Usuario? usuario;
    int? v;

    Bikes({
        this.id,
        this.etiqueta,
        this.marca,
        this.modelo,
        this.codigoSerie,
        this.colorPrincipal,
        this.tipo,
        this.aro,
        this.modeloCuadro,
        this.talla,
        this.imagen,
        this.usuario,
        this.v,
    });

    factory Bikes.fromJson(Map<String, dynamic> json) => Bikes(
        id: json["_id"],
        etiqueta: json["etiqueta"],
        marca: json["marca"],
        modelo: json["modelo"],
        codigoSerie: json["codigo_serie"],
        colorPrincipal: json["color_principal"],
        tipo: json["tipo"],
        aro: json["aro"],
        modeloCuadro: json["modelo_cuadro"],
        talla: json["talla"],
        imagen: List<String>.from(json["imagen"].map((x) => x)),
        usuario: Usuario.fromJson(json["usuario"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "etiqueta": etiqueta,
        "marca": marca,
        "modelo": modelo,
        "codigo_serie": codigoSerie,
        "color_principal": colorPrincipal,
        "tipo": tipo,
        "aro": aro,
        "modelo_cuadro": modeloCuadro,
        "talla": talla,
        "imagen": imagen,
        "usuario": usuario?.toJson(),
        "__v": v,
    };
}

class Usuario {
    String? id;
    String? nombre;
    String? apellidos;
    String? email;
    String? region;
    String? comuna;
    String? rol;
    List<String>? imagen;
    List<dynamic>? bicicletas;
    List<dynamic>? recorridos;
    int? v;

    Usuario({
        this.id,
        this.nombre,
        this.apellidos,
        this.email,
        this.region,
        this.comuna,
        this.rol,
        this.imagen,
        this.bicicletas,
        this.recorridos,
        this.v,
    });

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["_id"],
        nombre: json["nombre"],
        apellidos: json["apellidos"],
        email: json["email"],
        region: json["region"],
        comuna: json["comuna"],
        rol: json["rol"],
        imagen: List<String>.from(json["imagen"].map((x) => x)),
        bicicletas: List<dynamic>.from(json["bicicletas"].map((x) => x)),
        recorridos: List<dynamic>.from(json["recorridos"].map((x) => x)),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "apellidos": apellidos,
        "email": email,
        "region": region,
        "comuna": comuna,
        "rol": rol,
        'imagen': imagen,
        'bicicletas': bicicletas,
        'recorridos': recorridos,
        "__v": v,
    };
}
