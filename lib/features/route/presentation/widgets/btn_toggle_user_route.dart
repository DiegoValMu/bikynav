
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../app/helpers/real_time_provider.dart';

class BtnToggleUserRoute extends StatelessWidget {
  const BtnToggleUserRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    //final searchBloc = BlocProvider.of<SearchBloc>(context);
      final stopwatchProvider = Provider.of<StopwatchProvider>(context);

    final LatLng? position = locationBloc.state.lastKnowlocation;

    return InkWell(
      child: const Padding(
        padding: EdgeInsets.symmetric( vertical: 10, horizontal: 20 ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.route),
            Text('Trazar ruta'),
          ],
        ),
      ),
      onTap: () {
        stopwatchProvider.resetTimer();
        final startMarker = Marker(
          markerId: const MarkerId('start'),
          position: position!,
          infoWindow: const InfoWindow(
            title: 'Ubicación inicial',
          )
        );

        final myRoute = Polyline(
          polylineId: const PolylineId('myRoute'),
          color: Colors.black54,
          width: 5,
          points: [position], // Inicia con solo la posición actual
        );

        final currentPolylines = Map<String, Polyline>.from(mapBloc.state.polylines);
        currentPolylines['myRoute'] = myRoute;

        final currentMarkers = Map<String, Marker>.from( mapBloc.state.markers );
        currentMarkers['start'] = startMarker;
        mapBloc.add( DisplayMarkerEvent( currentMarkers ) );
        
        mapBloc.add(OnToggleUserRoute());
        locationBloc.add( OnNewRouteEvent(position));
        mapBloc.add(OnInitRoute());
      },
    );
  }
}
