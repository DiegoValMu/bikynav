

import 'package:google_maps_flutter/google_maps_flutter.dart';

class BikeRoute {
  String? nombre;
  String? ubicacionInicial;
  String? ubicacionFinal;
  DateTime? fecha;
  double? distancia;
  int? tiempoUtilizado;
  Map<String, Polyline> ruta;
  String? imagen;

  BikeRoute({
    this.nombre,
    this.ubicacionInicial,
    this.ubicacionFinal,
    this.fecha,
    this.distancia,
    this.tiempoUtilizado,
    required this.ruta,
    this.imagen,
  });
}