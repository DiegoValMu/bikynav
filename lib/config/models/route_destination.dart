
import 'package:bikynav/config/models/places_models.dart';
import 'package:bikynav/config/models/traffic_response_cycling.dart' as cycling_models;
import 'package:google_maps_flutter/google_maps_flutter.dart';


class RouteDestination {
  final List<LatLng> points;
  final double duration;
  final double distance;
  final dynamic endPlace;
  final int initialBearing;
  final List<dynamic> alternativeRoutes;
  final List<cycling_models.Step> intersections; 

  RouteDestination({
    required this.points,
    required this.duration,
    required this.distance,
    required this.endPlace,
    required this.initialBearing,
    required this.alternativeRoutes,
    required this.intersections,
  });

  factory RouteDestination.fromJson(Map<String, dynamic> json) {
    return RouteDestination(
      points: (json['points'] as List).map((p) => LatLng(p[0], p[1])).toList(),
      duration: json['duration'],
      distance: json['distance'],
      endPlace: Place.fromJson(json['endPlace']), 
      initialBearing: json['initialBearing'], 
      alternativeRoutes: json['alternativeRoutes'], 
      intersections: json['intersections'],
      // ... otras propiedades ...
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((p) => [p.latitude, p.longitude]).toList(),
      'duration': duration,
      'distance': distance,
      'endPlace': endPlace.toJson(),
      'initialBearing': initialBearing,
      'alternativeRoutes': alternativeRoutes,
      'intersections': intersections
      // ... otras propiedades ...
    };
  }
}