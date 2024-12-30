import 'dart:convert';

import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bikynav/features/nav/presentation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Ajusta el tamaño del AppBar
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Iniciar-sesion.png'), // Ruta de tu imagen
                fit: BoxFit.cover,
              ),
            ),
          ),
          backgroundColor: Colors.transparent, // Hace el fondo transparente
          elevation: 0, // Elimina la sombra del AppBar
          centerTitle: true,
          // Cambiar el color de los íconos, incluyendo la flecha de retroceso
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const SafeArea(
          child: _LoginFormView(),
        ),
      ),
    );
  }
}

class _LoginFormView extends StatefulWidget {
  const _LoginFormView();

  @override
  State<_LoginFormView> createState() => _LoginFormViewState();
}

class _LoginFormViewState extends State<_LoginFormView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  

  Future<void> _loginUser() async {
  try {
    // Intentar iniciar sesión con Firebase Auth
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    String? idToken = await credential.user?.getIdToken();
    // Usuario autenticado con éxito
    print('Usuario autenticado: ${credential.user?.email}');
    
   
    // Realiza la petición al backend
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/login'),
      headers: {
        'Authorization': 'Bearer $idToken', // Incluye el token en el encabezado
        'Content-Type': 'application/json',
      }
    );

   


    if (response.statusCode == 200) {

      print(response.body);

      final Map<String, dynamic> userData = json.decode(response.body);

      final userServices = Provider.of<UserServices>(context, listen: false);
      userServices.userData(userData['_id']);
      //// Petición exitosa, redirige al usuario
      //context.go('/loading');
    } else {
      // Error en el backend
      throw Exception('Error en el backend: ${response.body}');
    }

    context.go('/loading');

  } catch (e) {
    // Manejo de errores
    print('Error al iniciar sesión: ${e.toString()}');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error en firebase'),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 20),

            const Image(
              image: AssetImage('assets/images/login.png'),
              height: 150,
            ),

            const SizedBox(height: 20),

            CustomTextFormField(
              icon: Icons.email,
              placeholder: 'Correo electronico',
              inputType: TextInputType.emailAddress,
              controller: emailController, // Asocia el controlador
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              icon: Icons.lock,
              placeholder: 'Contraseña',
              isPassword: true,
              controller: passwordController, // Asocia el controlador
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _loginUser, // Llama al método de inicio de sesión
                  child: const Text('Iniciar sesión', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
