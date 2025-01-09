
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.route), // Icono que representa la acción
        title: const Text('Trazar ruta'), // Título
        onTap: () {

          stopwatchProvider.resetTimer();



          final startMarker = Marker(
            markerId: const MarkerId('start'),
            position: position!,
            infoWindow: const InfoWindow(
              title: 'Ubicación inicial',
            )
          );

          final currentMarkers = Map<String, Marker>.from( mapBloc.state.markers );
          currentMarkers['start'] = startMarker;

          mapBloc.add( DisplayMarkerEvent( currentMarkers ) );
        //como hago para agregar este marcador al state
          
          mapBloc.add(OnToggleUserRoute());
          locationBloc.add( OnNewRouteEvent(position));
          mapBloc.add(OnInitRoute());

        },
      ),
    );
  }
}
