import 'dart:convert';

import 'package:bikynav/features/nav/config/themes/wmc2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';

class MapView extends StatelessWidget {
 
  final LatLng initialLocation;
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  final Function(GoogleMapController)? onMapCreated;
  final MapType mapType;
  final void Function(LatLng)? onLongPress;

  MapView({
    super.key, 
    required this.initialLocation, 
    required this.polylines, 
    required this.markers,
    this.mapType = MapType.normal, 
    this.onMapCreated, 
    this.onLongPress
    });

  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context);

    final CameraPosition initialCameraPosition = CameraPosition(
            target: initialLocation,
            zoom: 15,
          );

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: ( pointerMoveEvent ) => mapBloc.add( OnStopFollowingUserEvent() ),
        child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                compassEnabled: false,
                myLocationEnabled: true,
                trafficEnabled: true,
                myLocationButtonEnabled: false,
                indoorViewEnabled: false,
                zoomControlsEnabled: false,
                liteModeEnabled: false,
                polylines: polylines,
                markers: markers,
                style: jsonEncode(wmc2MapTheme),
                onMapCreated: onMapCreated,
                onCameraMove: ( position ) {
                  mapBloc.updateCurrentCameraPosition(position);
                  mapBloc.mapCenter = position.target;
                  
                  //mapBloc.add(OnToggleDegreeView(false, position.bearing));
                },
                onLongPress: onLongPress,
                
                mapType: mapType,
              //TODO: Markers
      
              ),
      ),
    );
  }
}