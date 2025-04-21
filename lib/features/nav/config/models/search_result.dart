import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchResult {


  final String id; 
  final bool cancel;
  final bool manual;
  final LatLng? position;
  final String? name;
  final String? description;

  SearchResult({
    required this.cancel, 
    this.manual = false,
    this.position, 
    this.name, 
    this.description,
    this.id = ''
    });

  @override
  String toString() {
    return '{ cancel: $cancel, manual: $manual}';
  }

}