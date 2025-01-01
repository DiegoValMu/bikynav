import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:bikynav/features/route/config/models/routes.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/config/models/models.dart';
import 'package:bikynav/features/nav/config/themes/themes.dart';

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

    on<OnCancelRoute>((event, emit) => emit( state.copyWith( inRoute:  false )));

    on<DisplayPolylinesEvent>((event, emit) => emit( state.copyWith( polylines: event.polylines, markers: event.markers )));

    on<OnInitRoute>((event, emit) => emit( state.copyWith( inRoute:  true )));
  
    locationBloc.stream.listen((locationState) { 

      if (locationState.lastKnowlocation != null) {
        add( UpdateUserPolylineEvent( locationState.myLocationHistory ) );
      }

      if ( !state.isfollowingUser ) return;
      if ( locationState.lastKnowlocation == null ) return;
      
      moveCamera( locationState.lastKnowlocation! );

    });
  }

  void _onInitMap( OnMapInitializedEvent event, Emitter<MapState> emit) {

    _mapController = event.controller;
    //_mapController?.animateCamera();

    _mapController!.setMapStyle( jsonEncode( wmc2MapTheme )  );
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

  Future drawRoutePolyline ( RouteDestination destination ) async {

    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      width: 5,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap
      );

      double kms = destination.distance / 1000;
      kms = (kms * 10).roundToDouble() / 10;

      double tripDuration = (destination.duration / 60).floorToDouble();

      final startMarker = Marker(
        markerId: const MarkerId('start'),
        position: destination.points.first,
        infoWindow: const InfoWindow(
          title: 'Ubicación inicial',
        )
        );

      final endMarker = Marker(
        markerId: const MarkerId('end'),
        position: destination.points.last,
        infoWindow: InfoWindow(
          title: 'Destino',
          snippet: destination.endPlace.properties.name
        )
        );  

      final currentPolylines = Map<String, Polyline>.from( state.polylines );
      currentPolylines['route'] = myRoute;

      final currentMarkers = Map<String, Marker>.from( state.markers );
      currentMarkers['start'] = startMarker;
      currentMarkers['end'] = endMarker;


      add( DisplayPolylinesEvent( currentPolylines, currentMarkers ) );

      await Future.delayed(const Duration( milliseconds: 300 ) );

      _mapController?.showMarkerInfoWindow( const MarkerId( 'end' ) );

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
