import 'package:bikynav/features/route/config/models/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteServices with ChangeNotifier {

  RouteServices();

  Future<bool> routeRegister( BikeRoute rt ) async {

    Map<String, dynamic> route;

    route = {
      'nombre': rt.nombre,
      'distancia': rt.distancia,
      'ubicacion_inicial': rt.ubicacionInicial,
      'ubicacion_final': rt.ubicacionFinal,
      'tiempo': rt.tiempoUtilizado,
      'ruta': rt.ruta,
      'fecha': rt.fecha.toString(),
      'usuario': rt.user,
    };



    final response = await http.post(
      Uri.parse('https://serverbikynav-production.up.railway.app/api/recorridos'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(route),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      // Error en el backend
      throw Exception('Error en el backend: ${response.body}');
    }
  }


}

