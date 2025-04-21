import 'dart:async';

import 'package:bikynav/features/nav/app/helpers/helpers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/config/models/models.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;

  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({
    required this.locationBloc
    }) : super(const MapState()) {

    on<OnMapInitializedEvent>( _onInitMap);
    on<OnStartFollowingUserEvent>( _onStartFollowingUser );
    on<OnStopFollowingUserEvent>((event, emit) => emit( state.copyWith( isfollowingUser: false )));

    on<UpdateUserPolylineEvent>( _onPolylineNewPoint);

    on<OnToggleUserRoute>((event, emit) => emit( state.copyWith( showMyRoute:  true )));
    on<OnCancelToggleUserRoute>((event, emit) => emit( state.copyWith( showMyRoute: false )));

    on<OnCancelRoute>((event, emit) => emit( state.copyWith( onInitRoute:  false, onSelectRoute: false )));

    on<DisplayMarkerEvent>((event, emit) => emit( state.copyWith( markers: event.markers )));

    on<DisplayPolylinesEvent>((event, emit) {
      // Combina los polylines existentes con los nuevos
      final combinedPolylines = {...state.polylines, ...event.polylines};
      // Combina los markers existentes con los nuevos
      final combinedMarkers = {...state.markers, ...event.markers};

      emit(state.copyWith(
        polylines: combinedPolylines,
        markers: combinedMarkers
      ));
    });

    on<OnInitRoute>((event, emit) => emit( state.copyWith( onInitRoute:  true )));

    on<OnSelectRoute>((event, emit) => emit( state.copyWith( onSelectRoute:  true )));

    on<MoveCameraToLocationEvent>((event, emit) {
      moveCamera(event.location);
    });
  
    locationBloc.stream.listen((locationState) { 

      if (locationState.lastKnowlocation != null) {
        add( UpdateUserPolylineEvent( locationState.myLocationHistory ) );
      }

      if ( !state.isfollowingUser ) return;
      if ( locationState.lastKnowlocation == null ) return;
      
      //moveCamera( locationState.lastKnowlocation! );

    });
  }

  void _onInitMap( OnMapInitializedEvent event, Emitter<MapState> emit) {

    _mapController = event.controller;
    //_mapController?.animateCamera();

    emit( state.copyWith( isMapInitialized: true ) );

  }

  void _onStartFollowingUser( OnStartFollowingUserEvent event, Emitter<MapState> emit){
    emit( state.copyWith( isfollowingUser: true)  );

    if( locationBloc.state.lastKnowlocation == null ) return;
    moveCamera(locationBloc.state.lastKnowlocation! );

  }

  void _onPolylineNewPoint (UpdateUserPolylineEvent event, Emitter<MapState> emit){
    final myRoute = Polyline(
      polylineId: const PolylineId('myRoute'),
      color: Colors.black54,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userLocations
      );

      final currentPolylines = Map<String, Polyline>.from( state.polylines );
      currentPolylines['myRoute'] = myRoute;

      emit (state.copyWith(polylines: currentPolylines));

  }

  Future drawRoutePolyline(RouteDestination destination) async {
  final startMarker = await getAssetImageMarker('start_marker.png', 39, 48);
  final endMarker = await getAssetImageMarker('check_end_marker.png', 48, 48 );
  // Usamos IDs distintos para la ruta de "Cómo llegar"
  final navigationRoute = Polyline(
    polylineId: const PolylineId('navigationRoute'), // ID diferente
    color: const Color.fromARGB(185, 0, 0, 0), // Color distinto para diferenciar
    width: 5,
    points: destination.points,
    startCap: Cap.roundCap,
    endCap: Cap.roundCap
  );

  final navigationStartMarker = Marker(
    markerId: const MarkerId('navigationStart'), // ID diferente
    position: destination.points.first,
    infoWindow: const InfoWindow(title: 'Inicio de navegación'),
    anchor: const Offset(0.5, 1.0),
    icon: startMarker
  );

  final navigationEndMarker = Marker(
    markerId: const MarkerId('navigationEnd'), // ID diferente
    position: destination.points.last,
    infoWindow: InfoWindow(
      title: 'Destino de navegación',
      snippet: destination.endPlace.properties.name
    ),
    icon: endMarker
  );

  // Conservamos TODOS los elementos existentes
  final currentPolylines = Map<String, Polyline>.from(state.polylines);
  currentPolylines['navigationRoute'] = navigationRoute;

  final currentMarkers = Map<String, Marker>.from(state.markers);
  currentMarkers['navigationStart'] = navigationStartMarker;
  currentMarkers['navigationEnd'] = navigationEndMarker;

  add(DisplayPolylinesEvent(currentPolylines, currentMarkers));

  add(MoveCameraToLocationEvent(destination.points.last));

  await Future.delayed(const Duration(milliseconds: 300));
  _mapController?.showMarkerInfoWindow(const MarkerId('navigationEnd'));
}

  void moveCamera ( LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }

}
