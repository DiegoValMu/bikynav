part of 'location_bloc.dart';

class LocationState extends Equatable {
  
  final bool followingUser;
  final LatLng? lastKnowlocation;
  final List<LatLng> myLocationHistory;
  //ultima geolocation
  //historia
  

  
  
  const LocationState({
    this.followingUser = false,
    this.lastKnowlocation, 
    myLocationHistory, 
  }): myLocationHistory = myLocationHistory ?? const [];

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKnowlocation,
    List<LatLng>? myLocationHistory,
  }) => LocationState(
    followingUser : followingUser ?? this.followingUser,
    lastKnowlocation : lastKnowlocation ?? this.lastKnowlocation,
    myLocationHistory : myLocationHistory ?? this.myLocationHistory,
  );
  
  @override
  List<Object?> get props => [followingUser, lastKnowlocation, myLocationHistory];
}
