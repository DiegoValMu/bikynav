import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BikeRoute {
  String? id;
  String? nombre;
  LatLng? ubicacionInicial;
  LatLng? ubicacionFinal;
  DateTime? fecha;
  double? distancia;
  int? tiempoUtilizado;
  Map<String, Polyline>? ruta; // Ahora es opcional para evitar errores
  List<String>? imagen; // Manejado como lista para coincidir con la respuesta del backend
  String? user;

  BikeRoute({
    this.id,
    this.nombre,
    this.ubicacionInicial,
    this.ubicacionFinal,
    this.fecha,
    this.distancia,
    this.tiempoUtilizado,
    this.ruta,
    this.user,
    this.imagen,
  });

  factory BikeRoute.fromJson(Map<String, dynamic> json) {
    return BikeRoute(
      id: json['_id'], // ID asignado por el backend
      nombre: json['nombre'],
      ubicacionInicial: json['ubicacion_inicial'] != null
          ? LatLng(
              (json['ubicacion_inicial'][0] as num).toDouble(),
              (json['ubicacion_inicial'][1] as num).toDouble(),
            )
          : null,
      ubicacionFinal: json['ubicacion_final'] != null
          ? LatLng(
              (json['ubicacion_final'][0] as num).toDouble(),
              (json['ubicacion_final'][1] as num).toDouble(),
            )
          : null,
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : null,
      distancia: json['distancia'] != null
          ? (json['distancia'] as num).toDouble()
          : null,
      tiempoUtilizado: json['tiempo'] != null ? int.tryParse(json['tiempo']) : null,
      ruta: json['ruta'] != null
          ? _parsePolylines(json['ruta'] as Map<String, dynamic>)
          : null,
      imagen: json['imagen'] != null ? List<String>.from(json['imagen']) : [],
      user: json['usuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nombre': nombre,
      'ubicacion_inicial': ubicacionInicial != null
          ? [ubicacionInicial!.latitude, ubicacionInicial!.longitude]
          : null,
      'ubicacion_final': ubicacionFinal != null
          ? [ubicacionFinal!.latitude, ubicacionFinal!.longitude]
          : null,
      'fecha': fecha?.toIso8601String(),
      'distancia': distancia,
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
      'usuario': user,
    };
  }

  static Map<String, Polyline> _parsePolylines(Map<String, dynamic> rutaJson) {
    return rutaJson.map((key, value) {
      final points = (value['points'] as List<dynamic>)
          .map((point) => LatLng((point[0] as num).toDouble(), (point[1] as num).toDouble()))
          .toList();
      return MapEntry(
        key,
        Polyline(
          polylineId: PolylineId(key),
          points: points,
          color: Color(value['color']),
          width: value['width'],
        ),
      );
    });
  }
}
