import 'package:bikynav/app/helpers/show_loading_message.dart';
import 'package:bikynav/app/services/user_services.dart';
import 'package:bikynav/presentation/Usuarios/views/delete_account.dart';
import 'package:bikynav/presentation/Usuarios/views/sensitive_info_section.dart';
import 'package:bikynav/presentation/Usuarios/views/user_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateUserDataScreen extends StatefulWidget {
  const UpdateUserDataScreen({super.key});

  @override
  State<UpdateUserDataScreen> createState() => _UpdateUserDataScreenState();
}

class _UpdateUserDataScreenState extends State<UpdateUserDataScreen> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController apellidoController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

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
  }

  void _initializeControllers() {
    final userServices = Provider.of<UserServices>(context, listen: false);
    final userData = userServices.usuario;

    emailController = TextEditingController(text: userData.email);
    nameController = TextEditingController(text: userData.nombre);
    apellidoController = TextEditingController(text: userData.apellidos);
    passwordController = TextEditingController(text: '');
    confirmPasswordController = TextEditingController(text: '');
    selectedRegion = userData.region;
    selectedComuna = userData.comuna;
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    apellidoController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                offset: Offset(0, 0),
                blurRadius: 6,
              ),
            ],
          ),
          child: AppBar(
            title: const Text('Actualizar información'),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  confirmDeleteAccount(context);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _updateUserForm(context),
    );
  }

  Stack _updateUserForm(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UserFormSection(
                  emailController: emailController,
                  nombreController: nameController,
                  apellidoController: apellidoController,
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
                  passwordController: passwordController,
                  confirmPasswordController: confirmPasswordController,
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
    );
  }

  
}