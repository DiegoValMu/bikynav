import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? positionStream;

  LocationBloc() : super(const LocationState()) {
    on<OnStartFollowingUser>((event, emit) => emit(state.copyWith(followingUser: true)));
    on<OnStopFollowingUser>((event, emit) => emit(state.copyWith(followingUser: false)));
    on<OnNewRouteEvent>((event, emit) {
      emit(
        state.copyWith(
          lastKnowlocation: event.newLocation,
          myLocationHistory: [event.newLocation],
          speed: null, // Resetear velocidad en nueva ruta
        ),
      );
    });
    on<OnNewUserLocationEvent>((event, emit) {
      emit(
        state.copyWith(
          lastKnowlocation: event.newLocation,
          myLocationHistory: [...state.myLocationHistory, event.newLocation],
          speed: event.speed, // Actualizar velocidad
        ),
      );
    });
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
  }

  Future getCurrentPosition() async {
    await checkLocationPermission();

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation, // Mejor precisión para velocidad
      distanceFilter: 0,
    );

    final position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    add(OnNewUserLocationEvent(
      LatLng(position.latitude, position.longitude),
      position.speed, // Incluir velocidad
    ));
  }

  void startFollowingUser() async {
    await checkLocationPermission();
    positionStream?.cancel();
    add(OnStartFollowingUser());
    
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 3, // metros (ajustable)
    );

    positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        add(OnNewUserLocationEvent(
          LatLng(position.latitude, position.longitude),
          position.speed >= 0 ? position.speed : null, // Filtrar valores negativos
        ));
      },
      onError: (error) {
        print('Error in position stream: $error');
      },
    );
  }

  void stopFollowingUser() {
    positionStream?.cancel();
    positionStream = null;
    add(OnStopFollowingUser());
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }
}