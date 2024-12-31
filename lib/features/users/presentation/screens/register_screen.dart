// ignore_for_file: use_build_context_synchronously

import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:bikynav/features/nav/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Ajusta el tamaño del AppBar
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Registro-de-usuarios.png'), // Ruta de tu imagen
                fit: BoxFit.cover,
              ),
            ),
          ),
          backgroundColor: Colors.transparent, // Hace el fondo transparente
          elevation: 0, // Elimina la sombra del AppBar
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white), // Cambiar el color de los íconos
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // Foto y texto al lado
                  Row(
                    children: [
                      const SizedBox(width: 20), // Espaciado desde la izquierda
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 40, // Tamaño del círculo
                            backgroundColor: Colors.grey.shade300, // Fondo gris claro
                            child: const Icon(
                              Icons.person, // Ícono de persona
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            bottom: 2, // Ajusta la posición vertical del ícono
                            right: 2, // Ajusta la posición horizontal del ícono
                            child: Container(
                              width: 20, // Tamaño reducido del botón
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.deepPurple, // Fondo del botón
                                shape: BoxShape.circle, // Forma circular
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 14, // Tamaño del ícono
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Este Padding mueve el texto hacia abajo
                      const Padding(
                        padding: EdgeInsets.only(left: 10, top: 30), // Ajusta top para mover el texto abajo
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Imagen Perfil', // Texto al lado de la foto
                              style: TextStyle(
                                fontSize: 20, // Tamaño del texto
                                color: Colors.black, // Color del texto
                              ),
                            ),
                            Text(
                              '(opcional)', // Texto al lado de la foto
                              style: TextStyle(
                                fontSize: 16, // Tamaño del texto
                                color: Colors.black, // Color del texto
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const _RegisterForm(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _emailController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _regionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          CustomTextFormField(
            controller: _emailController,
            icon: Icons.email,
            placeholder: 'Correo electronico',
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            controller: _nombreController,
            icon: Icons.person,
            placeholder: 'Nombre',
            inputType: TextInputType.name,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            controller: _apellidoController,
            icon: Icons.person,
            placeholder: 'Apellido',
            inputType: TextInputType.name,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            controller: _ciudadController,
            icon: Icons.location_city,
            placeholder: 'Ciudad',
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            controller: _regionController,
            icon: Icons.home,
            placeholder: 'Región',
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            controller: _passwordController,
            icon: Icons.lock,
            placeholder: 'Contraseña',
            isPassword: true,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            controller: _confirmPasswordController,
            icon: Icons.lock,
            placeholder: 'Repetir Contraseña',
            isPassword: true,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  final confirmPassword = _confirmPasswordController.text.trim();

                  if (password != confirmPassword) {
                    // Mostrar un mensaje de error si las contraseñas no coinciden
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Las contraseñas no coinciden")),
                    );
                    return;
                  }

                  try {
                    // Crear usuario con Firebase Auth
                    // ignore: unused_local_variable
                    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    var db = FirebaseFirestore.instance;

                    final user = <String, dynamic>{
                      'email': email,
                      'nombre': _nombreController.text.trim(),
                      'apellidos': _apellidoController.text.trim(),
                      'ciudad': _ciudadController.text.trim(),
                      'region': _regionController.text.trim(),
                    };

                    try {

                      //Guardar los datos del usuario en mongodb
                      final userServices = Provider.of<UserServices>(context, listen: false);
                      await userServices.userRegister(user);

                      // Guardar los datos del usuario en Firestore
                      await db.collection("users").add(user).then((DocumentReference doc) {
                        print('DocumentSnapshot added with ID: ${doc.id}');
                      });

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Usuario registrado con exito'),
                          content: const Icon( Icons.check_circle ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );

                    } catch (e) {
                      print("Error al guardar los datos en Firestore: $e");
                    }

                    // Redirigir o mostrar mensaje de éxito
                    context.go('/login');
                  } on FirebaseAuthException catch (e) {
                    // Manejo de errores
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Error desconocido")));
                  }
                },
                child: const Text('Registrar datos', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
