part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUser;
  final LatLng? lastKnowlocation;
  final List<LatLng> myLocationHistory;
  final double? speed; // Añadir velocidad al estado

  const LocationState({
    this.followingUser = false,
    this.lastKnowlocation,
    List<LatLng>? myLocationHistory,
    this.speed,
  }) : myLocationHistory = myLocationHistory ?? const [];

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKnowlocation,
    List<LatLng>? myLocationHistory,
    double? speed,
  }) {
    return LocationState(
      followingUser: followingUser ?? this.followingUser,
      lastKnowlocation: lastKnowlocation ?? this.lastKnowlocation,
      myLocationHistory: myLocationHistory ?? this.myLocationHistory,
      speed: speed ?? this.speed,
    );
  }

  @override
  List<Object?> get props => [
    followingUser, 
    lastKnowlocation, 
    myLocationHistory,
    speed,
  ];
}