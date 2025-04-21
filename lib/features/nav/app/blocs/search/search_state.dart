part of 'search_bloc.dart';

class SearchState extends Equatable {

  final bool displayManualMarker;
  final List<Feature> places;
  final List<Feature> history;
  final String selectedPlace;

  const SearchState({
    this.displayManualMarker = false,
    this.places = const [],
    this.history = const [],
    this.selectedPlace = ''
    });

  SearchState copyWith({
    bool? displayManualMarker,
    List<Feature>? places,
    List<Feature>? history,
    selectPlace
  }) => SearchState(
    displayManualMarker: displayManualMarker ?? this.displayManualMarker,
    places: places ?? this.places,
    history: history ?? this.history,
    selectedPlace: selectedPlace ?? this.selectedPlace
  );
  
  @override
  List<Object> get props => [ displayManualMarker, places, history, selectedPlace ];
}


