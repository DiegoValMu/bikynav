import 'dart:convert';

import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/nav/presentation/widgets/widgets.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../config/models/country.dart'; // Para manejo de estado global

class UpdateUserDataScreen extends StatefulWidget {
  const UpdateUserDataScreen({super.key});

  @override
  State<UpdateUserDataScreen> createState() => _UpdateUserDataScreenState();
}

class _UpdateUserDataScreenState extends State<UpdateUserDataScreen> {
  late TextEditingController nameController;
  late TextEditingController apellidoController;
  late TextEditingController comunaController;
  late TextEditingController regionController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  

  List<Region> regiones = [];
  List<String> comunas = [];
  String? selectedRegion;
  String? selectedComuna;

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadRegionsAndComunas();
  }

  void _initializeControllers() {
    final userServices = Provider.of<UserServices>(context, listen: false);
    final userData = userServices.usuario;

    nameController = TextEditingController(text: userData.nombre);
    apellidoController = TextEditingController(text: userData.apellidos);
    comunaController = TextEditingController(text: userData.comuna);
    passwordController = TextEditingController(text: '');
    confirmPasswordController = TextEditingController(text: '');

    regionController = TextEditingController(text: userData.region);
    _updateComunas(regionController.text);
  }

  Future<void> _loadRegionsAndComunas() async {
    final String response = await rootBundle.loadString('assets/data/regiones_comunas.json');
    final data = json.decode(response) as Map<String, dynamic>;

    final countryData = CountryData.fromMap(data);

    setState(() {
      selectedComuna = comunaController.text;
      selectedRegion = regionController.text;
      regiones = countryData.regions;
    });
  }

  void _updateComunas(String regionName) async {
      // Cargar el archivo JSON
      final String response = await rootBundle.loadString('assets/data/regiones_comunas.json');
  
      // Decodificar el JSON
      final data = json.decode(response) as Map<String, dynamic>;
  
      // Crear la instancia de CountryData a partir del JSON
      final countryData = CountryData.fromMap(data);
  
      // Encontrar la región correspondiente por su nombre
      final selectedRegion = countryData.regions.firstWhere(
        (region) => region.name == regionName
      );

      selectedComuna = null;
  
      // Si la región es válida, actualizar las comunas
      if (selectedRegion != null) {
        setState(() {
          
          // Asignar las comunas de la región seleccionada
          comunas = selectedRegion.communes.map((commune) => commune.name).toList();
        });
      } else {
        // Si no se encuentra la región, manejar el caso apropiadamente
        setState(() {
          comunas = [];
        });
      }
    }

    

  @override
  void dispose() {
    nameController.dispose();
    apellidoController.dispose();
    comunaController.dispose();
    regionController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: AppBar(
          title: const Text('Actualizar información'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
      ),
    ),
    body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Información basica',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: nameController,
                  placeholder: nameController.text,
                  icon: Icons.person,
                  inputType: TextInputType.name,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: apellidoController,
                  placeholder: apellidoController.text,
                  icon: Icons.person,
                  inputType: TextInputType.name,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedRegion,
                  items: regiones
                      .map((region) => DropdownMenuItem<String>(
                            value: region.name,
                            child: Text(region.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRegion = value!;
                      selectedComuna = null;
                      comunas.clear();
                      if (value != null) {
                        _updateComunas(value);
                      }
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Región',
                    prefixIcon: const Icon(Icons.home, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedComuna,
                  items: comunas
                      .map((comuna) => DropdownMenuItem<String>(
                            value: comuna,
                            child: Text(comuna),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedComuna = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Comuna',
                    prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Información sensible',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: passwordController,
                  icon: Icons.lock,
                  placeholder: 'Contraseña',
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: confirmPasswordController,
                  icon: Icons.lock,
                  placeholder: 'Repetir Contraseña',
                  isPassword: true,
                ),
                const SizedBox(height: 80), // Espacio para el botón
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final currentPasswordController = TextEditingController();

                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirmar actualización'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Ingrese su contraseña actual para confirmar los cambios.'),
                            const SizedBox(height: 10),
                            TextField(
                              controller: currentPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Contraseña actual',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Cerrar el diálogo sin realizar acción
                            },
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (currentPasswordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Por favor, ingrese su contraseña actual.')),
                                );
                                return;
                              }
                              Navigator.of(context).pop(currentPasswordController.text); // Devolver la contraseña ingresada
                            },
                            child: const Text('Confirmar'),
                          ),
                        ],
                      );
                    },
                  ).then((currentPassword) async {
                    if (currentPassword == null) return; // Si no se ingresó contraseña, no continuar

                    showLoadingMessage(context);

                    final userServices = Provider.of<UserServices>(context, listen: false);
                    final userData = userServices.usuario;

                    final formData = {
                      'nombre': capitalize(nameController.text),
                      'apellidos': capitalize(apellidoController.text),
                      'comuna': selectedComuna,
                      'region': selectedRegion,
                    };

                    if (passwordController.text == confirmPasswordController.text) {
                      try {
                        await userServices.updateUser(
                          userData.id!,
                          formData,
                          passwordController.text,
                          currentPassword, // Contraseña actual ingresada
                        );
                        hideLoadingMessage(context);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Información actualizada correctamente')),
                        );
                      } catch (e) {
                      hideLoadingMessage(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al actualizar: $e')),
                      );
                    }
                  } else {
                    hideLoadingMessage(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Las contraseñas no coinciden.')),
                    );
                  }
                });
              },

                child: const Text('Guardar'),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

}
