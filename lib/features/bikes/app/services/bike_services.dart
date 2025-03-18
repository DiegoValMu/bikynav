import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';

class BikeServices with ChangeNotifier {

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


}