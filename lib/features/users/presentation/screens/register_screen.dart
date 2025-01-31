// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:bikynav/features/users/config/models/country.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:bikynav/features/nav/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  List<Region> regiones = [];
  List<String> comunas = [];
  String? selectedRegion;
  String? selectedComuna;

  bool _isKeyboardVisible = false; 

  @override
  void initState() {
    super.initState();
    _loadRegionsAndComunas();

    WidgetsBinding.instance.addObserver(this);
  }

 
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  Future<void> _loadRegionsAndComunas() async {
    final response = await rootBundle.loadString('assets/data/regiones_comunas.json');
    final countryData = CountryData.fromMap(json.decode(response));
    setState(() => regiones = countryData.regions);
  }

  void _updateComunas(String regionName) async {
    final response = await rootBundle.loadString('assets/data/regiones_comunas.json');
    final countryData = CountryData.fromMap(json.decode(response));
    final selectedRegion = countryData.regions.firstWhere((region) => region.name == regionName);
    setState(() => comunas = selectedRegion.communes.map((commune) => commune.name).toList());
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
                _buildSection(
                  title: 'Información básica',
                  children: [
                    const Divider(),
                    const SizedBox(height: 10,),
                    CustomTextFormField(controller: _emailController, icon: Icons.email, placeholder: 'Correo electronico', inputType: TextInputType.emailAddress),
                    const SizedBox(height: 10,),
                    CustomTextFormField(controller: _nombreController, icon: Icons.person, placeholder: 'Nombre', inputType: TextInputType.name),
                    const SizedBox(height: 10,),
                    CustomTextFormField(controller: _apellidoController, icon: Icons.person, placeholder: 'Apellido', inputType: TextInputType.name),
                    const SizedBox(height: 10,),
                    _buildDropdown(
                      value: selectedRegion,
                      label: 'Región',
                      items: regiones.map((region) => region.name).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRegion = value;
                          selectedComuna = null;
                          comunas.clear();
                          if (value != null) _updateComunas(value);
                        });
                      },
                    ),
                    const SizedBox(height: 10,),
                    _buildDropdown(
                      value: selectedComuna,
                      label: 'Comuna',
                      items: comunas,
                      onChanged: (value) => setState(() => selectedComuna = value),
                    ),
                    const SizedBox(height: 10,),
                  ],
                ),
                const SizedBox(height: 10),
                _buildSection(
                  title: 'Información sensible',
                  children: [
                    const Divider(),
                    const SizedBox(height: 10,),
                    CustomTextFormField(controller: _passwordController, icon: Icons.lock, placeholder: 'Contraseña', isPassword: true),
                    const SizedBox(height: 10,),
                    CustomTextFormField(controller: _confirmPasswordController, icon: Icons.lock, placeholder: 'Repetir Contraseña', isPassword: true),
                    const SizedBox(height: 10,),
                  ],
                ),
              ],
            ),
          ),
        ),
        (_isKeyboardVisible)
        ? Text('')
        : Align(
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
                      'comuna': selectedComuna,
                      'region': selectedRegion,
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

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), 
            offset: const Offset(0, 2), 
            blurRadius: 6)
          ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ExpansionTile(
          leading: IconButton(padding: EdgeInsets.zero, onPressed: () {}, icon: const Icon(Icons.info)),
          title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          initiallyExpanded: true,
          maintainState: true,
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
          children: children,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).primaryColor)),
      ),
    );
  }
}
