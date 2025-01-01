import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<double> calculateDistanceUsingGeolocator(LatLng point1, LatLng point2) async {
  double distance = await Geolocator.distanceBetween(
    point1.latitude, point1.longitude,
    point2.latitude, point2.longitude,
  );
  return distance / 1000; // Convertir a kilómetros
}

