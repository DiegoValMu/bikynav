

import 'dart:convert';

import 'package:bikynav/config/models/markers_model.dart';
import 'package:bikynav/config/models/models.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MarkerServices with ChangeNotifier {

  List<Markers> infoMarkers = [];

  Feature? dataActualPlace;

  Marker? setMarker;

  String? markersSelected;

  MarkerServices();

  Future<bool> markerRegister( Map<String, dynamic> marker ) async {
    final response = await http.post(
      Uri.parse('https://serverbikynav-production.up.railway.app/api/markers'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(marker),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      // Error en el backend
      throw Exception('Error en el backend: ${response.body}');
    }
  }

  Future getMarkers() async {

    final response = await http.get(Uri.parse('https://serverbikynav-production.up.railway.app/api/markers'));
    if (response.statusCode == 200) {
      final List<dynamic> decodedJson = json.decode(response.body);

      // Utiliza .map para transformar cada elemento dinámico en un objeto Markers
      infoMarkers = decodedJson.map((item) => Markers.fromJson(item as Map<String, dynamic>)).toList();

      notifyListeners();  // Notifica a los consumidores
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  Future getTallerMarkers(String ciudad) async {

    final response = await http.get(Uri.parse('https://serverbikynav-production.up.railway.app/api/markers/taller/$ciudad'));
    if (response.statusCode == 200) {
      final List<dynamic> decodedJson = json.decode(response.body);

      // Utiliza .map para transformar cada elemento dinámico en un objeto Markers
      infoMarkers = decodedJson.map((item) => Markers.fromJson(item as Map<String, dynamic>)).toList();

      notifyListeners();  // Notifica a los consumidores
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  Future getEventMarkers(String ciudad) async {

    final response = await http.get(Uri.parse('https://serverbikynav-production.up.railway.app/api/markers/evento/$ciudad'));
    if (response.statusCode == 200) {
      final List<dynamic> decodedJson = json.decode(response.body);

      // Utiliza .map para transformar cada elemento dinámico en un objeto Markers
      infoMarkers = decodedJson.map((item) => Markers.fromJson(item as Map<String, dynamic>)).toList();

      notifyListeners();  // Notifica a los consumidores
    } else {
      throw Exception('Error al cargar los datos');
    }
  }



}
