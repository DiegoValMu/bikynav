part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class OnNewUserLocationEvent extends LocationEvent {
  final LatLng newLocation;
  final double? speed; // Añadir velocidad al evento

  const OnNewUserLocationEvent(this.newLocation, [this.speed]);
  
  @override
  List<Object> get props => [newLocation, speed ?? 0];
}

class OnNewRouteEvent extends LocationEvent {
  final LatLng newLocation;

  const OnNewRouteEvent(this.newLocation);
  
  @override
  List<Object> get props => [newLocation];
}

class UpdateDistanceFilter extends LocationEvent {
  final int distanceFilter;
  const UpdateDistanceFilter(this.distanceFilter);
  
  @override
  List<Object> get props => [distanceFilter];
}

class OnStartFollowingUser extends LocationEvent {}
class OnStopFollowingUser extends LocationEvent {}