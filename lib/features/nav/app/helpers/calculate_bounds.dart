import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLngBounds latLngBoundsForRoute(List<LatLng> points) {
  var sw = points[0];
  var ne = points[0];

  for (final point in points) {
    sw = LatLng(
      min(sw.latitude, point.latitude),
      min(sw.longitude, point.longitude),
    );
    ne = LatLng(
      max(ne.latitude, point.latitude),
      max(ne.longitude, point.longitude),
    );
  }

  double latDifference = ne.latitude - sw.latitude;

  // Define el factor para el padding inferior
  double bottomPaddingFactor = 0.1;
  double bottomLatPadding = latDifference * bottomPaddingFactor;

  // Crea un nuevo punto suroeste con la latitud ajustada (hacia el sur)
  LatLng newSw = LatLng(sw.latitude - bottomLatPadding, sw.longitude);

  // Retorna el nuevo LatLngBounds ajustado, manteniendo la latitud del noreste original
  return LatLngBounds(southwest: newSw, northeast: ne);
}