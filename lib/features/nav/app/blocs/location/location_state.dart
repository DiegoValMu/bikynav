part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUser;
  final LatLng? lastKnowlocation;
  final List<LatLng> myLocationHistory;

  const LocationState({
    this.followingUser = false,
    this.lastKnowlocation,
    List<LatLng>? myLocationHistory,
  }) : myLocationHistory = myLocationHistory ?? const [];

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKnowlocation,
    List<LatLng>? myLocationHistory,
  }) {
    return LocationState(
      followingUser: followingUser ?? this.followingUser,
      lastKnowlocation: lastKnowlocation ?? this.lastKnowlocation,
      myLocationHistory: myLocationHistory ?? this.myLocationHistory,
    );
  }

  @override
  List<Object?> get props => [followingUser, lastKnowlocation, myLocationHistory];
}
