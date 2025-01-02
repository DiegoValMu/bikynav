import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class BikeRoute {
  String? id;
  String? etiqueta;
  LatLng? ubicacionInicial;
  LatLng? ubicacionFinal;
  DateTime? fecha;
  int? tiempoUtilizado;
  Map<String, Polyline>? ruta;
  List<String>? imagen;
  User? usuario;
  String? usrId;
  double? distancia;  // Nueva propiedad para la distancia

  BikeRoute({
    this.id,
    this.etiqueta,
    this.ubicacionInicial,
    this.ubicacionFinal,
    this.fecha,
    this.tiempoUtilizado,
    this.ruta,
    this.imagen,
    this.usuario,
    this.distancia,
  });

  factory BikeRoute.fromJson(Map<String, dynamic> json) {
    var ubicacionInicial = json['ubicacion_inicial'] != null
        ? LatLng(
            (json['ubicacion_inicial'][0] as num).toDouble(),
            (json['ubicacion_inicial'][1] as num).toDouble(),
          )
        : null;
    var ubicacionFinal = json['ubicacion_final'] != null
        ? LatLng(
            (json['ubicacion_final'][0] as num).toDouble(),
            (json['ubicacion_final'][1] as num).toDouble(),
          )
        : null;

    double? distancia = ubicacionInicial != null && ubicacionFinal != null
        ? _calcularDistancia(ubicacionInicial, ubicacionFinal)
        : null;

    return BikeRoute(
      id: json['_id'],
      etiqueta: json['etiqueta'],  // Asumiendo que el nombre de la ruta viene desde el backend
      ubicacionInicial: ubicacionInicial,
      ubicacionFinal: ubicacionFinal,
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : null,
      tiempoUtilizado: json['tiempo'] != null ? int.tryParse(json['tiempo']) : null,
      ruta: json['ruta'] != null
          ? _parsePolylines(json['ruta'] as Map<String, dynamic>)
          : null,
      imagen: json['imagen'] != null ? List<String>.from(json['imagen']) : [],
      usuario: json['usuario'] != null ? User.fromJson(json['usuario']) : null,
      distancia: distancia,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'etiqueta': etiqueta,
      'ubicacion_inicial': ubicacionInicial != null
          ? [ubicacionInicial!.latitude, ubicacionInicial!.longitude]
          : null,
      'ubicacion_final': ubicacionFinal != null
          ? [ubicacionFinal!.latitude, ubicacionFinal!.longitude]
          : null,
      'fecha': fecha?.toIso8601String(),
      'tiempo': tiempoUtilizado?.toString(),
      'ruta': ruta?.map((key, polyline) => MapEntry(key, {
                'polylineId': polyline.polylineId.value,
                'points': polyline.points
                    .map((point) => [point.latitude, point.longitude])
                    .toList(),
                'color': polyline.color.value,
                'width': polyline.width,
              })),
      'imagen': imagen,
      'usuario': usuario?.toJson(),
      'distancia': distancia,
    };
  }

  static Map<String, Polyline> _parsePolylines(Map<String, dynamic> rutaJson) {
    return rutaJson.map((key, value) {
      final points = (value['points'] as List<dynamic>)
          .map((point) => LatLng(
                (point[0] as num).toDouble(),
                (point[1] as num).toDouble(),
              ))
          .toList();
      return MapEntry(
        key,
        Polyline(
          polylineId: PolylineId(key),
          points: points,
          color: Color((value['color'] as num).toInt()),
          width: (value['width'] as num).toInt(),
        ),
      );
    });
  }

  // Método para calcular la distancia entre dos puntos usando la fórmula de Haversine
  static double _calcularDistancia(LatLng punto1, LatLng punto2) {
    const R = 6371; // Radio de la Tierra en kilómetros
    double lat1 = punto1.latitude * pi / 180;
    double lon1 = punto1.longitude * pi / 180;
    double lat2 = punto2.latitude * pi / 180;
    double lon2 = punto2.longitude * pi / 180;

    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;

    double a = sin(dlat / 2) * sin(dlat / 2) +
        cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distancia en kilómetros
  }
}

class User {
  String? id;
  String? nombre;
  String? apellidos;
  DateTime? fechaNacimiento;
  String? telefono;
  String? email;
  String? direccion;
  String? rol;
  List<String>? imagen;
  List<dynamic>? bicicletas;
  List<dynamic>? recorridos;

  User({
    this.id,
    this.nombre,
    this.apellidos,
    this.fechaNacimiento,
    this.telefono,
    this.email,
    this.direccion,
    this.rol,
    this.imagen,
    this.bicicletas,
    this.recorridos,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      fechaNacimiento: json['fecha_nacimiento'] != null
          ? DateTime.parse(json['fecha_nacimiento'])
          : null,
      telefono: json['telefono'],
      email: json['email'],
      direccion: json['direccion'],
      rol: json['rol'],
      imagen: json['imagen'] != null ? List<String>.from(json['imagen']) : [],
      bicicletas: json['bicicletas'] != null
          ? List<dynamic>.from(json['bicicletas'])
          : [],
      recorridos: json['recorridos'] != null
          ? List<dynamic>.from(json['recorridos'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nombre': nombre,
      'apellidos': apellidos,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'rol': rol,
      'imagen': imagen,
      'bicicletas': bicicletas,
      'recorridos': recorridos,
    };
  }
}
