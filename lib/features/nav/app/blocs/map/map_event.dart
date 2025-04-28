part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}


class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController controller;
  const OnMapInitializedEvent (this.controller);
}

class OnToggleDegreeView extends MapEvent {
  final bool enable;
  final double bearing;
  final double zoom;

  const OnToggleDegreeView(this.enable, this.bearing, this.zoom);
}



class OnStopFollowingUserEvent extends MapEvent {}
class OnStartFollowingUserEvent extends MapEvent {}

class UpdateUserPolylineEvent extends MapEvent {
  final List<LatLng> userLocations;
  const UpdateUserPolylineEvent (this.userLocations);
}

class OnToggleUserRoute extends MapEvent {}
class OnCancelToggleUserRoute extends MapEvent {}
class OnCancelRoute extends MapEvent {}
class OnSelectRoute extends MapEvent {}
class OnInitRoute extends MapEvent {}
class OnCancelRoutes extends MapEvent {}
class OnSelectRoutes extends MapEvent {}
class OnCancelTallerMarker extends MapEvent {}
class OnSelectTallerMarker extends MapEvent {}

class MoveCameraToLocationEvent extends MapEvent {
  final LatLng location;
  const MoveCameraToLocationEvent(this.location);

  @override
  List<Object> get props => [location];
}

class FocusOnRouteEvent extends MapEvent {  // <-- Extiende MapEvent
  final List<LatLng> routePoints;
  
  const FocusOnRouteEvent(this.routePoints);
  
  @override
  List<Object> get props => [routePoints];
}

class DisplayPolylinesEvent extends MapEvent{
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
  const DisplayPolylinesEvent(this.polylines, this.markers);

  @override
  List<Object> get props => [polylines, markers];
}

class DisplayMarkerEvent extends MapEvent{
  final Map<String, Marker> markers;
  const DisplayMarkerEvent(this.markers);
}

class GetCurrentRouteEvent extends MapEvent{
  final RouteDestination? currentRoute;
  const GetCurrentRouteEvent(this.currentRoute);
}