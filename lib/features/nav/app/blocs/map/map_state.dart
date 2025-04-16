part of 'map_bloc.dart';

class MapState extends Equatable {

  final bool isMapInitialized;
  final bool isfollowingUser;
  final bool showMyRoute;
  final bool onInitRoute;
  final bool onSelectRoute;
 
  //polylines
  final Map<String, Polyline> polylines;
  //markers
  final Map<String, Marker> markers;


  const MapState({
    this.showMyRoute = false,  
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
    this.isMapInitialized = false, 
    this.isfollowingUser = false,
    this.onInitRoute = false,
    this.onSelectRoute = false,
  }): polylines = polylines ?? const {},
      markers = markers ?? const {};


  MapState copyWith({
    bool? isMapInitialized,
    bool? isfollowingUser,
    bool? showMyRoute,
    bool? onInitRoute,
    bool? onSelectRoute,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isfollowingUser: isfollowingUser ?? this.isfollowingUser,
    polylines: polylines ?? this.polylines,
    showMyRoute: showMyRoute ?? this.showMyRoute,
    markers: markers ?? this.markers,
    onSelectRoute: onSelectRoute ?? this.onSelectRoute,
    onInitRoute: onInitRoute ?? this.onInitRoute,
  );

  @override
  List<Object> get props => [ isMapInitialized, isfollowingUser, polylines, showMyRoute, markers , onInitRoute, onSelectRoute];
}

