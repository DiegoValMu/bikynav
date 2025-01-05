import 'package:bikynav/features/users/config/models/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    final response = await http.get(Uri.parse('https://serverbikynav-production.up.railway.app/api/usuarios/$id'));
    if (response.statusCode == 200) {
      exists = true;
      var data = json.decode(response.body);
      print('data: $data');

      print("id: ${data['_id']}");
      usuario.id = data['_id'];
      usuario.nombre = data['nombre'];
      usuario.apellidos = data['apellidos'];
      usuario.fechaNacimiento = data['fechaNacimiento'];
      usuario.telefono = data['telefono'];
      usuario.email = data['email'];
      usuario.direccion = data['direccion'];
      usuario.ciudad = data['ciudad'];
      usuario.region = data['region'];
      usuario.comuna = data['comuna'];


      print("nombre2: ${usuario.nombre}");  // Guarda los datos en la variable interna
      notifyListeners();  // Notifica a los consumidores
    } else {
      throw Exception('Error en el backend: ${response.body}');
    }
  }

  Future<String> authFireInMongo( String? idToken )async {
    final response = await http.post(
      Uri.parse('https://serverbikynav-production.up.railway.app/api/login'),
      headers: {
        'Authorization': 'Bearer $idToken', // Incluye el token en el encabezado
        'Content-Type': 'application/json',
      }
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // Error en el backend
      throw Exception('Error en el backend: ${response.body}');
    }
  }

  Future<bool> userRegister( Map<String, dynamic> user ) async {
    final response = await http.post(
      Uri.parse('https://serverbikynav-production.up.railway.app/api/usuarios'),
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

  Future deleteUser( String id) async {


    try {
    // Obtén la instancia del usuario actual
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Elimina el usuario
      await user.delete();
   
      final response = await http.delete(Uri.parse('https://serverbikynav-production.up.railway.app/api/usuarios/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al eliminar: ${response.body}');
      }
    } else {
      print("No hay usuario autenticado.");
    }
    } catch (e) {
      // Manejo de errores
      print("Error al eliminar usuario: $e");
    }

    
  }


}

