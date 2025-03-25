import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';

class BikeServices with ChangeNotifier {

  List<dynamic> bikes = [];

  bool? exists;

  BikeServices() {
    exists = false;
  }

 Future<bool> bikeRegister( Map<String, dynamic> bike ) async {
    final response = await http.post(
      Uri.parse('https://serverbikynav-production.up.railway.app/api/bicicletas'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bike),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      // Error en el backend
      throw Exception('Error en el backend: ${response.body}');
    }
  }

  Future getBikes( String id ) async {

    final response = await http.post(Uri.parse('https://serverbikynav-production.up.railway.app/api/bicicletasUsuario'),
    headers: {
      'Authorization': id,
    });
    if (response.statusCode == 200) {
      bikes = json.decode(response.body);
      notifyListeners();  // Notifica a los consumidores
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

    Future deleteBike( String id ) async {
      final response = await http.delete(Uri.parse('https://serverbikynav-production.up.railway.app/api/bicicletas/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al eliminar: ${response.body}');
      }
  }


}