import 'package:bikynav/features/route/app/helpers/real_time_provider.dart';
import 'package:bikynav/features/route/config/models/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class BtnSaveRoute extends StatelessWidget {
  const BtnSaveRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    final stopwatchProvider = Provider.of<StopwatchProvider>(context);

    BikeRoute myRoute;

    LatLng ubicacionInicial = locationBloc.state.myLocationHistory.first;
    LatLng? ubicacionFinal = locationBloc.state.lastKnowlocation;
    List<LatLng> coordinates = locationBloc.state.myLocationHistory;
    Map<String, Polyline> ruta = mapBloc.state.polylines;
    

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return TextButton.icon(
          onPressed: () async {
            stopwatchProvider.stopTimer();

            final startMarker = Marker(
              markerId: const MarkerId('end'),
              position: ubicacionFinal!,
              infoWindow: const InfoWindow(
                title: 'Ubicación final',
              )
            );

            final currentMarkers = Map<String, Marker>.from( mapBloc.state.markers );
            currentMarkers['end'] = startMarker;
  
            mapBloc.add( DisplayMarkerEvent( currentMarkers ) );

            myRoute = BikeRoute(
              nombre: '',
              tiempoUtilizado: stopwatchProvider.totalTimeStopped,
              ubicacionInicial: ubicacionInicial.toString(),
              ruta: ruta
            );

            for (int i = 0; i < coordinates.length - 1; i++) {
              LatLng point1 = coordinates[i];
              LatLng point2 = coordinates[i + 1];

              double distance = await Geolocator.distanceBetween(
                point1.latitude, point1.longitude,
                point2.latitude, point2.longitude,
              );

              myRoute.distancia = distance;
            }

            myRoute.nombre = '';
            myRoute.tiempoUtilizado = stopwatchProvider.totalTimeStopped;
            myRoute.ubicacionInicial = ubicacionInicial.toString();
            myRoute.ubicacionFinal = ubicacionFinal.toString();
            myRoute.ruta = ruta;
            myRoute.fecha = DateTime.now();

            print('route: $myRoute');

            
            mapBloc.add( OnCancelRoute() );

            // Lógica del botón
          },
          icon: const Icon(Icons.save),
          label: const Text('Guardar ruta'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            side: const BorderSide(color: Colors.purple, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25), // Bordes redondeados
            ),
          ),
        );
      },
    );
  }
}
