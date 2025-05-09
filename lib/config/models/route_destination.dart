
import 'package:bikynav/config/models/traffic_response_cycling.dart' as cycling_models;
import 'package:google_maps_flutter/google_maps_flutter.dart';


class RouteDestination {
  final List<LatLng> points;
  final double duration;
  final double distance;
  final dynamic endPlace;
  final int initialBearing;
  final List<cycling_models.Step> intersections; 

  RouteDestination({
    required this.points,
    required this.duration,
    required this.distance,
    required this.endPlace,
    required this.initialBearing,
    required this.intersections,
  });
}