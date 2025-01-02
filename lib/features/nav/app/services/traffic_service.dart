import 'package:bikynav/features/nav/config/models/traffic_response_cycling.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:bikynav/features/nav/config/models/models.dart';
import 'package:bikynav/features/nav/app/services/services.dart';


class TrafficService {

  final Dio _dioTraffic;
  final Dio _dioPlaces;

  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';

  TrafficService()
    : _dioTraffic = Dio()..interceptors.add( TrafficInterceptor() ),
      _dioPlaces = Dio();


  Future<TrafficResponseCycling> getCoorsStartToEnd( LatLng start, LatLng end ) async {

    final coorsString = '${ start.longitude },${ start.latitude };${ end.longitude },${ end.latitude }';
    
    final url = '$_baseTrafficUrl/cycling/$coorsString';

    final resp = await _dioTraffic.get(url);

    final data = TrafficResponseCycling.fromMap(resp.data);
    
    return data;

  }

  Future<List<Feature>> getResultsByQuery( LatLng proximity, String query ) async {

    if( query.isEmpty ) return [];

    final url = 'https://api.mapbox.com/search/geocode/v6/forward?country=cl&language=es';

    //final url = '$_basePlacesUrl?q=$query&proximity=${ proximity.longitude},${ proximity.latitude }';

    final resp = await _dioPlaces.get( url, queryParameters: {
      'q': query,
      'proximity': '${ proximity.longitude},${ proximity.latitude }',
      'access_token': 'pk.eyJ1IjoiZGllZ28tdmFsZGVycmFtYS1tdSIsImEiOiJjbTIwdnh2eGwwMHNzMm9xNXF6a29kOXM1In0.Uo-wVrhKnVMGvNZX0D-KJQ'
    } );

    final placesResponse = PlacesResponse.fromMap( resp.data );

    return placesResponse.features;
  }

  Future<Feature> getInformationByCoors( LatLng coors ) async {
    final url = 'https://api.mapbox.com/search/geocode/v6/reverse?country=cl&language=es&continue_straight=true';

    final resp = await _dioPlaces.get( url, queryParameters: {
      'longitude': coors.longitude,
      'latitude': coors.latitude,
      'limit': 1,
      'access_token': 'pk.eyJ1IjoiZGllZ28tdmFsZGVycmFtYS1tdSIsImEiOiJjbTIwdnh2eGwwMHNzMm9xNXF6a29kOXM1In0.Uo-wVrhKnVMGvNZX0D-KJQ'
    } );

    final placesResponse = PlacesResponse.fromMap(resp.data);

    return placesResponse.features[0];
  }



}