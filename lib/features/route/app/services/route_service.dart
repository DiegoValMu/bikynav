import 'package:bikynav/features/route/config/models/routes.dart';
import 'package:bikynav/features/route/config/models/routesById.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteServices with ChangeNotifier {

  List<dynamic> rutas = [];

  BikeRoute myRoute = BikeRoute();

  RouteServices();


  Future<bool> routeRegister( BikeRoute rt ) async {

    Map<String, dynamic> route;

    route = {
      'etiqueta': rt.etiqueta,
      'distancia': rt.distancia,
      'ubicacion_inicial': rt.ubicacionInicial,
      'ubicacion_final': rt.ubicacionFinal,
      'tiempo': rt.tiempoUtilizado,
      'ruta': rt.ruta,
      'fecha': rt.fecha.toString(),
      'usuario': rt.usrId,
    };



    final response = await http.post(
      Uri.parse('https://serverbikynav-production.up.railway.app/api/recorridos'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(route),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      // Error en el backend
      throw Exception('Error en el backend: ${response.body}');
    }
  }

  Future getRoutes( String id) async {

    final response = await http.post(Uri.parse('https://serverbikynav-production.up.railway.app/api/recorridosUsuario'),
    headers: {
      'Authorization': id,
    });
    if (response.statusCode == 200) {
      rutas = json.decode(response.body);
      //var data = json.decode(response.body);
      print('data: $rutas');
      print("nombre2: ${myRoute.etiqueta}");  // Guarda los datos en la variable interna
      notifyListeners();  // Notifica a los consumidores
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  Future deleteRoute( String id) async {

    final response = await http.delete(Uri.parse('https://serverbikynav-production.up.railway.app/api/recorridos/$id'));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error en el backend: ${response.body}');
    }
  }

  Future getRouteById( String id ) async {

    final response = await http.get(Uri.parse('https://serverbikynav-production.up.railway.app/api/recorridos/$id'));
    if (response.statusCode == 200) {
      
      Map<String, dynamic> jsonMap = jsonDecode(response.body);

      // Convert to Ruta object
      Ruta ruta = Ruta.fromJson(jsonMap);
      
      return ruta;
    } else {
      throw Exception('Error en el backend: ${response.body}');
    }
  }


}

