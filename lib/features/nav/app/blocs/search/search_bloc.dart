import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:bikynav/features/nav/config/models/models.dart';
import 'package:bikynav/features/nav/app/services/services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  TrafficService trafficService;

  SearchBloc({
    required this.trafficService
  }) : super( const SearchState() ) {

    on<OnActivateManualMarkerEvent>((event, emit) => emit( state.copyWith( displayManualMarker: true ) ) );

    on<OnDesactivateManualMarkerEvent>((event, emit) => emit( state.copyWith( displayManualMarker: false ) ) );

    on<OnActivateManualPinMarkerEvent>((event, emit) => emit( state.copyWith( displayManualPinMarker: true ) ) );

    on<OnDesactivateManualPinMarkerEvent>((event, emit) => emit( state.copyWith( displayManualPinMarker: false ) ) );

    on<OnNewPlacesFoundEvent>((event, emit) => emit( state.copyWith( places: event.places ) ) );

    on<AddToHistoryEvent>((event, emit) => emit( state.copyWith( history: [ event.place, ...state.history ] ) ) );

  }

  Future getCoorsStartToEnd( LatLng start, LatLng end ) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd(start, end);

    //informacion del destino
    final endPlace = await trafficService.getInformationByCoors(end);

    final route = trafficResponse.routes[0];
    final distance = route.distance;
    final duration = route.duration;
    final geometry = route.geometry;

    final points = decodePolyline( geometry, accuracyExponent: 6);

    final latLngList = points.map( (coor) => LatLng( coor[0].toDouble(), coor[1].toDouble() ) ).toList();

    final initialBearing = route.legs[0].steps[0].maneuver.bearingAfter;
    final legs = route.legs[0].steps;

    //por ver duplicados
    double kms = distance / 1000;
    kms = (kms * 10).roundToDouble() / 10;
//
    endPlace.properties.distancia = kms;
    endPlace.properties.duracion = duration;

    if ( !state.history.contains( endPlace) ){
      add( AddToHistoryEvent( endPlace ) );
    }

    final destination = RouteDestination(
      points: latLngList, 
      duration: duration, 
      distance: distance,
      endPlace: endPlace, 
      initialBearing: initialBearing, // Añadir esto
      intersections: legs,
      );
    
    //emit(state.copyWith(currentRoute: destination ));

    return destination;
  }

  Future getPlacesByQuery( LatLng proximity, String query ) async {
    final newPlaces = await trafficService.getResultsByQuery(proximity, query);
   
    add( OnNewPlacesFoundEvent( newPlaces ) );
  }

}
