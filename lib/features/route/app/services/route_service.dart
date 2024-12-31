import 'package:bikynav/features/route/config/models/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteServices with ChangeNotifier {

  BikeRoute usuario = BikeRoute();
  bool? exists;

  RouteServices() {
    // Inicialmente, no hay usuario y no hay datos existentes
    exists = false;
  }

  Future<bool> routeRegister( Map<String, dynamic> user ) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/recorridos'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      // Error en el backend
      throw Exception('Error en el backend: ${response.body}');
    }
  }


}

