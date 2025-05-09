// ignore_for_file: use_build_context_synchronously

import 'package:bikynav/app/helpers/show_loading_message.dart';
import 'package:bikynav/app/services/user_services.dart';
import 'package:bikynav/presentation/Usuarios/views/sensitive_info_section.dart';
import 'package:bikynav/presentation/Usuarios/views/user_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Registro-de-usuarios.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: const _RegisterForm(),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> with WidgetsBindingObserver {
  final _emailController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? selectedRegion;
  String? selectedComuna;

  bool _isKeyboardVisible = false;
  final Map<String, String> _basicInfo = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _emailController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  String capitalize(String text) => text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UserFormSection(
                  emailController: _emailController,
                  nombreController: _nombreController,
                  apellidoController: _apellidoController,
                  initialRegion: selectedRegion,
                  initialComuna: selectedComuna,
                  onBasicInfoChanged: (data) {
                    setState(() {
                      selectedRegion = data['region'];
                      selectedComuna = data['comuna'];
                    });
                  },
                ),
                const SizedBox(height: 10),
                SensitiveInfoSection(
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                ),
                const SizedBox(height: 80), // Espacio para el botón
              ],
            ),
          ),
        ),
        if (!_isKeyboardVisible)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    showLoadingMessage(context);
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    final confirmPassword = _confirmPasswordController.text.trim();

                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Las contraseñas no coinciden")),
                      );
                      Navigator.of(context).pop();
                      return;
                    }

                    try {
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      final user = <String, dynamic>{
                        'email': email,
                        'nombre': capitalize(_nombreController.text.trim()),
                        'apellidos': capitalize(_apellidoController.text.trim()),
                        'comuna': _basicInfo['comuna'],
                        'region': _basicInfo['region'],
                      };

                      try {
                        final userServices = Provider.of<UserServices>(context, listen: false);
                        await userServices.userRegister(user);
                        await FirebaseFirestore.instance.collection("users").add(user);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Problemas con el servicio")),
                        );
                        Navigator.of(context).pop();
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Usuario registrado correctamente'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      context.go('/login');
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Error desconocido")));
                      Navigator.of(context).pop();
                    } finally {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const Text('Registrar'),
                ),
              ),
            ),
          ),
      ],
    );
  }
}