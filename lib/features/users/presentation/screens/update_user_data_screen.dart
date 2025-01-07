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

    regionController = TextEditingController(text: userData.region);
    _updateComunas(regionController.text);
  }

  Future<void> _loadRegionsAndComunas() async {
    final String response = await rootBundle.loadString('assets/data/regiones_comunas.json');
    final data = json.decode(response) as Map<String, dynamic>;

    final countryData = CountryData.fromMap(data);

    setState(() {
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
      appBar: AppBar(
        title: const Text('Actualizar información'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                value: regionController.text,
                items: regiones
                    .map((region) => DropdownMenuItem<String>(
                          value: region.name,
                          child: Text(region.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    regionController.text = value!;
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
                value: comunaController.text,
                items: comunas
                    .map((comuna) => DropdownMenuItem<String>(
                          value: comuna,
                          child: Text(comuna),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    comunaController.text = value!;
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
              const SizedBox(height: 20),


              ElevatedButton(
                onPressed: () async {
                  showLoadingMessage(context);

                  final userServices = Provider.of<UserServices>(context, listen: false);
                  final userData = userServices.usuario;

                  final formData = {
                    'nombre': capitalize(nameController.text),
                    'apellidos': capitalize(apellidoController.text),
                    'comuna': comunaController.text,
                    'region': regionController.text,
                  };

                  try {
                    await userServices.updateUser(userData.id!, formData);
                    hideLoadingMessage(context);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Información actualizada correctamente')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al actualizar: $e')),
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
