import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class Ruta {
  String id;
  String etiqueta;
  LatLng ubicacionInicial;
  LatLng ubicacionFinal;
  DateTime fecha;
  int tiempo;
  RutaDetalles rutaDetalles;

  Ruta({
    required this.id,
    required this.etiqueta,
    required this.ubicacionInicial,
    required this.ubicacionFinal,
    required this.fecha,
    required this.tiempo,
    required this.rutaDetalles,
  });

  factory Ruta.fromJson(Map<String, dynamic> json) {
    return Ruta(
      id: json['_id'],
      etiqueta: json['etiqueta'],
      ubicacionInicial: LatLng(
        json['ubicacion_inicial'][0],
        json['ubicacion_inicial'][1],
      ),
      ubicacionFinal: LatLng(
        json['ubicacion_final'][0],
        json['ubicacion_final'][1],
      ),
      fecha: DateTime.parse(json['fecha']),
      tiempo: int.parse(json['tiempo']),
      rutaDetalles: RutaDetalles.fromJson(json['ruta']['myRoute']),
    );
  }

  // Función para calcular la distancia total de la ruta en metros
  double calcularDistancia() {
    double distanciaTotal = 0.0;

    // Calculamos la distancia entre los puntos de la ruta
    for (int i = 0; i < rutaDetalles.points.length - 1; i++) {
      LatLng punto1 = rutaDetalles.points[i];
      LatLng punto2 = rutaDetalles.points[i + 1];
      distanciaTotal += _distanciaEntrePuntos(punto1, punto2);
    }

    return distanciaTotal;
  }

  // Función que calcula la distancia entre dos puntos en metros utilizando la fórmula de Haversine
  double _distanciaEntrePuntos(LatLng punto1, LatLng punto2) {
    const radioTierra = 6371000; // Radio de la Tierra en metros

    double lat1 = punto1.latitude * pi / 180;
    double lon1 = punto1.longitude * pi / 180;
    double lat2 = punto2.latitude * pi / 180;
    double lon2 = punto2.longitude * pi / 180;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    // Fórmula de Haversine
    double a = sin(dLat / 2) * sin(dLat / 2) +
               cos(lat1) * cos(lat2) *
               sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distancia en metros
    double distancia = radioTierra * c;

    return distancia;
  }
}

class RutaDetalles {
  String polylineId;
  bool consumeTapEvents;
  int color;
  List<String> endCap;
  bool geodesic;
  int jointType;
  List<String> startCap;
  bool visible;
  int width;
  int zIndex;
  List<LatLng> points;

  RutaDetalles({
    required this.polylineId,
    required this.consumeTapEvents,
    required this.color,
    required this.endCap,
    required this.geodesic,
    required this.jointType,
    required this.startCap,
    required this.visible,
    required this.width,
    required this.zIndex,
    required this.points,
  });

  factory RutaDetalles.fromJson(Map<String, dynamic> json) {
    return RutaDetalles(
      polylineId: json['polylineId'],
      consumeTapEvents: json['consumeTapEvents'],
      color: json['color'],
      endCap: List<String>.from(json['endCap']),
      geodesic: json['geodesic'],
      jointType: json['jointType'],
      startCap: List<String>.from(json['startCap']),
      visible: json['visible'],
      width: json['width'],
      zIndex: json['zIndex'],
      points: List<LatLng>.from(
        json['points'].map((point) => LatLng(point[0], point[1])),
      ),
    );
  }
}
