import 'package:bikynav/features/nav/app/blocs/map/map_bloc.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/features/route/config/models/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> onRouteTap(BuildContext context, BikeRoute route, MapBloc mapBloc, RouteServices routeServices) async {
  
    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: route.ubicacionInicial!,
      infoWindow: const InfoWindow(title: 'Ubicación inicial'),
    );

    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: route.ubicacionFinal!,
      infoWindow: InfoWindow(title: 'Destino', snippet: route.etiqueta),
    );

    final currentPolylines = Map<String, Polyline>.from(mapBloc.state.polylines);
    final points = route.ruta!['myRoute']?.points;
    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      width: 5,
      points: points!,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    final currentMarkers = Map<String, Marker>.from(mapBloc.state.markers);
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;
    currentPolylines['route'] = myRoute;

    mapBloc.add(DisplayPolylinesEvent(currentPolylines, currentMarkers));
    mapBloc.add(OnInitRoute());

    mapBloc.add(MoveCameraToLocationEvent(route.ubicacionInicial!));

    routeServices.myRoute = route;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Seleccionaste ${route.etiqueta ?? "una ruta"}')));
    context.push('/nav');
  }