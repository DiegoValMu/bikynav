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


  
  factory MapState.fromJson(Map<String, dynamic> json){
    return MapState(
      isMapInitialized: json['isMapInitialized'] ?? false,
      isfollowingUser: json['isfollowingUser'] ?? false,
      showMyRoute: json['showMyRoute'] ?? false,
      onInitRoute: json['onInitRoute'] ?? false,
      onSelectRoute: json['onSelectRoute'] ?? false,
      onSelectTallerMarker: json['onSelectTallerMarker'] ?? false,
      onSelectEventMarker: json['onSelectEventMarker'] ?? false,
      onSelectRoutes: json['onSelectRoutes'] ?? false,
      inSelectRoutes: json['inSelectRoutes'] ?? false,
      is45DegreeView: json['is45DegreeView'] ?? false,
      polylines: _polylinesFromJson(json['polylines']),
      markers: _markersFromJson(json['markers']),
      currentRoute: json['currentRoute'] != null 
          ? RouteDestination.fromJson(json['currentRoute']) 
          : null,
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'isMapInitialized': isMapInitialized,
      'isfollowingUser': isfollowingUser,
      'showMyRoute': showMyRoute,
      'onInitRoute': onInitRoute,
      'onSelectRoute': onSelectRoute,
      'onSelectTallerMarker': onSelectTallerMarker,
      'onSelectEventMarker': onSelectEventMarker,
      'onSelectRoutes': onSelectRoutes,
      'inSelectRoutes': inSelectRoutes,
      'is45DegreeView': is45DegreeView,
      'polylines': _polylinesToJson(polylines),
      'markers': _markersToJson(markers),
      'currentRoute': currentRoute?.toJson(),
    };
  }

  static Map<String, Polyline> _polylinesFromJson(Map<String, dynamic>? json) {
    if (json == null) return {};
    
    return json.map((key, value) => MapEntry(
      key,
      Polyline(
        polylineId: PolylineId(key),
        points: (value['points'] as List).map((p) => LatLng(p[0], p[1])).toList(),
        color: Color(value['color']),
        width: value['width'],
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    ));
  }

  static Map<String, dynamic> _polylinesToJson(Map<String, Polyline> polylines) {
    return polylines.map((key, polyline) => MapEntry(
      key,
      {
        'points': polyline.points.map((p) => [p.latitude, p.longitude]).toList(),
        'color': polyline.color.value,
        'width': polyline.width,
      },
    ));
  }

  static Map<String, Marker> _markersFromJson(Map<String, dynamic>? json) {
    if (json == null) return {};
    
    return json.map((key, value) => MapEntry(
      key,
      Marker(
        markerId: MarkerId(key),
        position: LatLng(value['position'][0], value['position'][1]),
        infoWindow: InfoWindow(
          title: value['infoWindow']['title'],
          snippet: value['infoWindow']['snippet'],
        ),
        icon: BitmapDescriptor.defaultMarker, // Esto se perderá en serialización
      ),
    ));
  }

  static Map<String, dynamic> _markersToJson(Map<String, Marker> markers) {
    return markers.map((key, marker) => MapEntry(
      key,
      {
        'position': [marker.position.latitude, marker.position.longitude],
        'infoWindow': {
          'title': marker.infoWindow.title,
          'snippet': marker.infoWindow.snippet,
        },
      },
    ));
  }


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

