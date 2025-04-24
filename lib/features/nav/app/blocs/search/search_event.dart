part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarkerEvent extends SearchEvent {}
class OnDesactivateManualMarkerEvent extends SearchEvent {}

class OnActivateManualPinMarkerEvent extends SearchEvent {}
class OnDesactivateManualPinMarkerEvent extends SearchEvent {}

class OnNewPlacesFoundEvent extends SearchEvent {
  final List<Feature> places;
  const OnNewPlacesFoundEvent(this.places);
}

class RemoveFromHistory extends SearchEvent {
  final String placeId;
  RemoveFromHistory(this.placeId);
}

class AddToHistoryEvent extends SearchEvent {
  final Feature place;
  const AddToHistoryEvent(this.place);
}