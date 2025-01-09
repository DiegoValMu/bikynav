import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart' as geo; // Alias para geolocator
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription<geo.ServiceStatus>? _gpsServiceSubscription;

  GpsBloc() : super(const GpsState(isGpsEnabled: false, isGpsPermissionGranted: false)) {
    on<GpsAndPermissionEvent>((event, emit) => emit(
          state.copyWith(
            isGpsEnabled: event.isGpsEnabled,
            isGpsPermissionGranted: event.isGpsPermissionGranted,
          ),
        ));
    _initializeGps();
  }

  Future<void> _initializeGps() async {
    // Verifica el estado inicial de GPS y permisos
    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _checkGpsPermission(),
    ]);

    // Emite el evento inicial
    add(GpsAndPermissionEvent(
      isGpsEnabled: gpsInitStatus[0],
      isGpsPermissionGranted: gpsInitStatus[1],
    ));

    // Escucha cambios en el estado del servicio GPS
    _gpsServiceSubscription = Geolocator.getServiceStatusStream().listen((status) {
      final isEnabled = status == geo.ServiceStatus.enabled; // Usamos el alias 'geo'
      add(GpsAndPermissionEvent(
        isGpsEnabled: isEnabled,
        isGpsPermissionGranted: state.isGpsPermissionGranted,
      ));
    });
  }

  Future<bool> _checkGpsStatus() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<bool> _checkGpsPermission() async {
    return await Permission.location.isGranted;
  }

  Future<void> requestGpsPermission() async {
    final status = await Permission.location.request();

    // Manejo de resultado del permiso
    if (status.isGranted) {
      add(GpsAndPermissionEvent(
        isGpsEnabled: state.isGpsEnabled,
        isGpsPermissionGranted: true,
      ));
    } else {
      add(GpsAndPermissionEvent(
        isGpsEnabled: state.isGpsEnabled,
        isGpsPermissionGranted: false,
      ));
      openAppSettings();
    }
  }

  @override
  Future<void> close() {
    _gpsServiceSubscription?.cancel();
    return super.close();
  }
}
