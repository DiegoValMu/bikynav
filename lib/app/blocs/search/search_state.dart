part of 'search_bloc.dart';

class SearchState extends Equatable {

  final bool displayManualMarker;
  final List<Feature> places;
  final List<Feature> history;
  final List<dynamic> alternativeRoutes;
  final String selectedPlace;
  final bool displayManualPinMarker;

  const SearchState({
    this.displayManualMarker = false,
    this.places = const [],
    this.history = const [],
    this.alternativeRoutes = const [],
    this.selectedPlace = '',
    this.displayManualPinMarker = false,
    });

  SearchState copyWith({
    bool? displayManualMarker,
    List<Feature>? places,
    List<Feature>? history,
    List<dynamic>? alternativeRoutes,
    bool? displayManualPinMarker,
    String? selectPlace
  }) => SearchState(
    displayManualMarker: displayManualMarker ?? this.displayManualMarker,
    places: places ?? this.places,
    history: history ?? this.history,
    selectedPlace: selectedPlace ?? this.selectedPlace,
    alternativeRoutes: alternativeRoutes ?? this.alternativeRoutes,
    displayManualPinMarker: displayManualPinMarker ?? this.displayManualPinMarker
  );
  
  @override
  List<Object> get props => [ displayManualMarker, places, history, selectedPlace, displayManualPinMarker, alternativeRoutes ];
}


