import 'package:bikynav/features/users/config/models/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      //print('data: $data');
      //print("id: ${data['_id']}");
      usuario.id = data['_id'];
      usuario.nombre = data['nombre'];
      usuario.apellidos = data['apellidos'];
      usuario.email = data['email'];
      usuario.region = data['region'];
      usuario.comuna = data['comuna'];
      //print("nombre2: ${usuario.nombre}");   Guarda los datos en la variable interna
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


  Future<void> updateUser(String id, Map<String, dynamic> formData, String password, String currentPassword ) async {

    final url = Uri.parse('https://serverbikynav-production.up.railway.app/api/usuarios/$id');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData),
      );

      if (response.statusCode == 200) {
        User? user = FirebaseAuth.instance.currentUser;

        DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc('userId');
        
        final updatedData = json.decode(response.body);
        usuario.id = updatedData['_id'];
        usuario.nombre = updatedData['nombre'];
        usuario.apellidos = updatedData['apellidos'];
        usuario.email = updatedData['email'];
        usuario.region = updatedData['region'];
        usuario.comuna = updatedData['comuna'];

        await docRef.set({
          'nombre': usuario.nombre,
          'apellidos': usuario.apellidos,
          'comuna': usuario.comuna,
          'region': usuario.region,
        });

        if ( password.isNotEmpty){
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: usuario.email!,
            password: currentPassword,
          );
          
          await user?.updatePassword( password );
        }
        
        notifyListeners(); 
 // Actualiza los datos locales
      } else {
        throw Exception('Error: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al actualizar: $e');
    }
  }

  Future deleteUser( String id, String password) async {
      User? user = FirebaseAuth.instance.currentUser;

      final response = await http.delete(Uri.parse('https://serverbikynav-production.up.railway.app/api/usuarios/$id'));
      if (response.statusCode == 200) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usuario.email!,
          password: password,
        );
        await user?.delete();
        await FirebaseAuth.instance.currentUser?.reload();
        return true;
      } else {
        throw Exception('Error al eliminar: ${response.body}');
      }
  }

  Future<void> deleteUserAccount() async {
  try {
    // Obtén el usuario autenticado
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Verifica si el usuario está autenticado
      await user.delete();
      print('Usuario eliminado correctamente.');
    } else {
      print('No hay usuario autenticado.');
    }
  } on FirebaseAuthException catch (e) {
    // Si el usuario necesita iniciar sesión nuevamente
    if (e.code == 'requires-recent-login') {
      print('El usuario debe iniciar sesión nuevamente para eliminar la cuenta.');
      // Aquí puedes pedirle al usuario que vuelva a iniciar sesión antes de proceder.
      
    } else {
      print('Error al eliminar el usuario: ${e.message}');
    }
  }
}


}

