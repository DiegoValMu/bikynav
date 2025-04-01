import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription? positionStream;

  LocationBloc() : super(const LocationState()) {
    on<OnStartFollowingUser>((event, emit) => emit(state.copyWith(followingUser: true)));
    on<OnStopFollowingUser>((event, emit) => emit(state.copyWith(followingUser: false)));
    on<OnNewRouteEvent>((event, emit) {
      emit(
        state.copyWith(
          lastKnowlocation: event.newLocation,
          myLocationHistory: [event.newLocation],
        ),
      );
    });
    on<OnNewUserLocationEvent>((event, emit) {
      emit(
        state.copyWith(
          lastKnowlocation: event.newLocation,
          myLocationHistory: [...state.myLocationHistory, event.newLocation],
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
    final position = await Geolocator.getCurrentPosition();

    print('Position:  $position');
    add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
  }

  void startFollowingUser() async {
    await checkLocationPermission();
    positionStream?.cancel(); // Cancela cualquier flujo previo
    add(OnStartFollowingUser());
    positionStream = Geolocator.getPositionStream().listen(
      (event) {
        final position = event;
        print('Position: $position');
        add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
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
