import 'package:bikynav/features/users/config/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserServices with ChangeNotifier {

  Usuario usuario = Usuario();
  bool? exists;

  UserServices() {
    // Inicialmente, no hay usuario y no hay datos existentes
    exists = false;
  }

  Future userData( String id) async {

    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/usuarios/$id'));
    if (response.statusCode == 200) {
      exists = true;
      var data = json.decode(response.body);
      print('data: $data');

      print("nombre1: ${data['nombre']}");
      usuario.nombre = data['nombre'];
      usuario.apellidos = data['apellidos'];
      usuario.fechaNacimiento = data['fechaNacimiento'];
      usuario.telefono = data['telefono'];
      usuario.email = data['email'];
      usuario.direccion = data['direccion'];

      
      print("nombre2: ${usuario.nombre}");  // Guarda los datos en la variable interna
      notifyListeners();  // Notifica a los consumidores
    } else {
      throw Exception('Error al cargar los datos');
    }
  }






  /*Map<String, dynamic> _userData = {};

  Map<String, dynamic> get userData => _userData;

  Future<void> fetchUserData(String id) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/usuarios/$id'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _userData = data;  // Guarda los datos en la variable interna
      notifyListeners();  // Notifica a los consumidores
    } else {
      throw Exception('Error al cargar los datos');
    }
  
  }*/


}

