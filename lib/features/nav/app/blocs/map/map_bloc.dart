import 'dart:async';
import 'package:bikynav/features/nav/app/helpers/calculate_bounds.dart';
import 'package:bikynav/features/nav/app/helpers/calculate_distance.dart';
import 'package:bikynav/features/nav/app/helpers/helpers.dart';
import 'package:bikynav/features/nav/app/services/marker_service.dart';
import 'package:bikynav/features/nav/config/models/markers_model.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/config/models/models.dart';
import 'package:bikynav/features/nav/config/models/traffic_response_cycling.dart' as cycling_models;
import 'package:provider/provider.dart';

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

    //activar vista 60°
    on<OnToggleDegreeView>(onToggleDegreeView);

    on<GetCurrentRouteEvent>((event, emit) => emit( state.copyWith( currentRoute: event.currentRoute )));

    //activar desactivar marcadores de rutas
    on<OnSelectRoutes>((event, emit) => emit( state.copyWith( onSelectRoutes:  true )));
    on<OnCancelRoutes>((event, emit) => emit( state.copyWith( onSelectRoutes:  false )));

    //activar desactivar marcadores de rutas
    on<OnSelectEventMarker>((event, emit) => emit( state.copyWith( onSelectEventMarker:  true )));
    on<OnCancelEventMarker>((event, emit) => emit( state.copyWith( onSelectEventMarker:  false )));

     //activar desactivar marcadores de rutas
    on<InSelectRoutes>((event, emit) => emit( state.copyWith( inSelectRoutes:  true )));
    on<InCancelRoutes>((event, emit) => emit( state.copyWith( inSelectRoutes:  false )));


    //activar desactivar marcadores de talleres
    on<OnSelectTallerMarker>((event, emit) => emit( state.copyWith( onSelectTallerMarker:  true )));
    on<OnCancelTallerMarker>((event, emit) => emit( state.copyWith( onSelectTallerMarker:  false )));

    on<FocusOnRouteEvent>(_focusOnRoute);

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

    //escuchar posicion de actual del usuario
  
    locationBloc.stream.listen((locationState) {
      if (state.showMyRoute) {
        add( UpdateUserPolylineEvent( locationState.myLocationHistory ) );
      }

      if (!state.isfollowingUser || locationState.lastKnowlocation == null) return;

      final currentLocation = locationState.lastKnowlocation!;

      final route = state.currentRoute;

      // 1. Si no hay ruta, usa bearing = 0
      if (route == null) {
        moveCamera(currentLocation);
        return;
      }

      // 2. Busca el step más cercano (punto de giro)
      double minDistance = double.infinity;

      for (final step in route.intersections) {
        final stepLatLng = LatLng(step.maneuver.location[0], step.maneuver.location[1]);
        final distance = calculateDistance(currentLocation, stepLatLng);
        if (distance < minDistance) {
          minDistance = distance;
        }
      }

      // 3. Si está cerca de un step, usa su bearingAfter
      const thresholdDistance = 10.0; // 10 metros para activar el giro

      if (minDistance <= thresholdDistance) {
      } else {
// Mantén el bearing inicial
      }

      // 4. Mueve la cámara con el bearing actualizado
      moveCamera(currentLocation);
    });
  }

  //---------------------------------------------------------------------------------------------------------------------
  void _onInitMap( OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    //_mapController?.animateCamera();

    emit( state.copyWith( isMapInitialized: true ) );

  }
  //---------------------------------------------------------------------------------------------------------------------

  //funcion para mantener la camara sobre la posicion del usuario y seguir su movimiento(solo con la camara)
  void _onStartFollowingUser( OnStartFollowingUserEvent event, Emitter<MapState> emit){
    emit( state.copyWith( isfollowingUser: true)  );
    if( locationBloc.state.lastKnowlocation == null ) return;
    moveCamera(locationBloc.state.lastKnowlocation! );
  }

  //---------------------------------------------------------------------------------------------------------------------

  //funcion para cambiar la vista a en grados, cambio de zoom y centra la camara a la posicion del usuario 
  void onToggleDegreeView(OnToggleDegreeView event, Emitter<MapState> emit) {
    emit(state.copyWith(is45DegreeView: event.enable));

    if (_mapController != null) {
      final newPosition = CameraPosition(
        target: locationBloc.state.lastKnowlocation!,
        zoom: event.enable ? event.zoom : 15,
        tilt: event.enable ? 65 : 0,
        bearing:  event.bearing,
      );
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(newPosition), duration: Duration(milliseconds: 300));
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------

  //cambio a vista general de la ruta seleccionada
  void _focusOnRoute(FocusOnRouteEvent event, Emitter<MapState> emit) {
    if (_mapController == null || event.routePoints.isEmpty) return;
  
    final bounds = latLngBoundsForRoute(event.routePoints);
    
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100), // 100px de padding
    );
  
    // Resetear vista 3D si está activa
    if (state.is45DegreeView) {
      emit(state.copyWith(is45DegreeView: false));
    }
  }

  //------------------------------------------------------------------------------------------------------------------------

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

      emit(state.copyWith(polylines: currentPolylines));
      moveCamera(event.userLocations.last);

  }

  //---------------------------------------------------------------------------------------------------------------------


  Future drawRoutePolyline(RouteDestination destination) async {

  add(GetCurrentRouteEvent(destination));

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

  //add(MoveCameraToLocationEvent(destination.points.last));
  
  await Future.delayed(const Duration(milliseconds: 300));
  
  add(MoveCameraToLocationEvent(destination.points.first));
  
  add(FocusOnRouteEvent(destination.points));

  

  _mapController?.showMarkerInfoWindow(const MarkerId('navigationEnd'));
}

  void moveCamera ( LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(
      cameraUpdate,
      duration: Duration(milliseconds: 300)
    );
  }

  void updateCurrentMarkerPosition(BuildContext context) {
    final markerServices = Provider.of<MarkerServices>(context, listen: false);
    BitmapDescriptor? eventMarker;

    if(state.onSelectEventMarker){
      eventMarker = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
    }

    if(state.onSelectTallerMarker){
      eventMarker = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    }

    markerServices.infoMarkers.forEach((Markers place) {

      if(state.markers.containsKey(place.id)){
        return;
      }
      // Accedemos a la latitud y longitud desde la propiedad 'pos' del objeto 'Markers'
      if (place.pos != null && place.pos!.length == 2) {
        final pos = LatLng(place.pos![0], place.pos![1]); // ¡OJO! El orden es [latitud, longitud] en tu JSON

        final newMarker = Marker(
          markerId: MarkerId(place.id ?? UniqueKey().toString()), // Usa el ID del objeto o genera uno único
          position: pos,
          infoWindow: InfoWindow(
            title: place.etiqueta ?? '', // Usa la etiqueta como título de la ventana de información
            // Puedes agregar más información aquí si lo deseas
          ),
          icon: eventMarker!,
          // Aquí puedes configurar otras propiedades del marcador si las necesitas
        );
        final updatedMarkers = Map<String, Marker>.from(state.markers);
        updatedMarkers[newMarker.markerId.value] = newMarker;
        add(DisplayMarkerEvent(updatedMarkers));
        
      }
    });
  }

   void updateRoutesMarkerPosition(BuildContext context) {
    final routeServices = Provider.of<RouteServices>(context, listen: false);
    BitmapDescriptor? eventMarker;

    eventMarker = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);

    routeServices.rutas2.forEach((place) {

      if(state.markers.containsKey(place["id"])  || state.inSelectRoutes){
        return;
      }
      // Accedemos a la latitud y longitud desde la propiedad 'pos' del objeto 'Markers'
      if (place["ubicacion_inicial"] != null && place["ubicacion_inicial"]!.length == 2) {
        final pos = LatLng(place["ubicacion_inicial"]![0], place["ubicacion_inicial"]![1]); // ¡OJO! El orden es [latitud, longitud] en tu JSON

        final newMarker = Marker(
          markerId: MarkerId(place["id"] ?? UniqueKey().toString()), // Usa el ID del objeto o genera uno único
          position: pos,
          infoWindow: InfoWindow(
            title: place["etiqueta"] ?? '', // Usa la etiqueta como título de la ventana de información
            // Puedes agregar más información aquí si lo deseas
          ),
          icon: eventMarker!,
          // Aquí puedes configurar otras propiedades del marcador si las necesitas
        );
        final updatedMarkers = Map<String, Marker>.from(state.markers);
        updatedMarkers[newMarker.markerId.value] = newMarker;
        add(DisplayMarkerEvent(updatedMarkers));
        add(InSelectRoutes());
      }
    });
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }

}

