part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUser;
  final LatLng? lastKnowlocation;
  final List<LatLng> myLocationHistory;
  final double? speed; // Añadir velocidad al estado
  final double? distanceFilter;

  const LocationState({
    this.followingUser = false,
    this.lastKnowlocation,
    List<LatLng>? myLocationHistory,
    this.speed,
    this.distanceFilter = 2
  }) : myLocationHistory = myLocationHistory ?? const [];

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKnowlocation,
    List<LatLng>? myLocationHistory,
    double? speed,
    double? distanceFilter,
  }) {
    return LocationState(
      followingUser: followingUser ?? this.followingUser,
      lastKnowlocation: lastKnowlocation ?? this.lastKnowlocation,
      myLocationHistory: myLocationHistory ?? this.myLocationHistory,
      speed: speed ?? this.speed,
      distanceFilter: distanceFilter ?? this.distanceFilter
    );
  }

  @override
  List<Object?> get props => [
    followingUser, 
    lastKnowlocation, 
    myLocationHistory,
    speed,
    distanceFilter
  ];
}