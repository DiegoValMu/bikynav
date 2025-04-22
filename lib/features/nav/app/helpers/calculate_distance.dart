import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

double calculateDistance(LatLng point1, LatLng point2) {
  const earthRadius = 6371000.0; // Radio de la Tierra en metros
  final lat1 = point1.latitude * (pi / 180);
  final lon1 = point1.longitude * (pi / 180);
  final lat2 = point2.latitude * (pi / 180);
  final lon2 = point2.longitude * (pi / 180);

  final dLat = lat2 - lat1;
  final dLon = lon2 - lon1;

  final a = sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}