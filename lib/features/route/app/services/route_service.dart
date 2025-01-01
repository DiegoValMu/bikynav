import 'package:bikynav/features/route/config/models/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteServices with ChangeNotifier {

  //BikeRoute route;
  bool? exists;

  RouteServices() {
    // Inicialmente, no hay usuario y no hay datos existentes
    exists = false;
  }

  Future<bool> routeRegister( Map<String, dynamic> rt ) async {
    final response = await http.post(
      Uri.parse('https://serverbikynav-production.up.railway.app/api/recorridos'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(rt),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      // Error en el backend
      throw Exception('Error en el backend: ${response.body}');
    }
  }


}

