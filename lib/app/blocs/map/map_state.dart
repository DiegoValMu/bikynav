part of 'map_bloc.dart';

class MapState extends Equatable {

  final bool isMapInitialized;
  final bool isfollowingUser;
  final bool showMyRoute;
  final bool onInitRoute;
  final bool onSelectRoute;
  final bool onSelectTallerMarker;
  final bool onSelectEventMarker;
  final bool onSelectRoutes;
  final bool inSelectRoutes;  
  final bool is45DegreeView;
  
 
  //polylines
  final Map<String, Polyline> polylines;
  //markers
  final Map<String, Marker> markers;

  final RouteDestination? currentRoute;


  const MapState({
    this.showMyRoute = false,  
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
    this.isMapInitialized = false, 
    this.isfollowingUser = false,
    this.onInitRoute = false,
    this.onSelectRoute = false,
    this.onSelectTallerMarker = false,
    this.onSelectEventMarker = false,
    this.onSelectRoutes = false,
    this.inSelectRoutes = false,
    this.is45DegreeView = false,
    this.currentRoute
  }): polylines = polylines ?? const {},
      markers = markers ?? const {};


  MapState copyWith({
    bool? isMapInitialized,
    bool? isfollowingUser,
    bool? showMyRoute,
    bool? onInitRoute,
    bool? onSelectRoute,
    bool? onSelectTallerMarker,
    bool? onSelectEventMarker,
    bool? onSelectRoutes,
    bool? inSelectRoutes,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
    bool? is45DegreeView,
    RouteDestination? currentRoute,
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isfollowingUser: isfollowingUser ?? this.isfollowingUser,
    polylines: polylines ?? this.polylines,
    showMyRoute: showMyRoute ?? this.showMyRoute,
    markers: markers ?? this.markers,
    onSelectRoute: onSelectRoute ?? this.onSelectRoute,
    inSelectRoutes: inSelectRoutes ?? this.inSelectRoutes,
    onSelectRoutes: onSelectRoutes ?? this.onSelectRoutes,
    onSelectTallerMarker: onSelectTallerMarker ?? this.onSelectTallerMarker,
    onSelectEventMarker: onSelectEventMarker ?? this.onSelectEventMarker,
    onInitRoute: onInitRoute ?? this.onInitRoute,
    is45DegreeView: is45DegreeView ?? this.is45DegreeView,
    currentRoute: currentRoute ?? this.currentRoute,
  );

  @override
  List<Object> get props => [ 
    isMapInitialized, 
    isfollowingUser, polylines, 
    showMyRoute, 
    markers , 
    onInitRoute, 
    onSelectRoute, 
    is45DegreeView, 
    currentRoute ?? '',
    onSelectRoutes,
    onSelectTallerMarker,
    onSelectEventMarker,
    inSelectRoutes
    ];
}

