import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:bikynav/features/users/presentation/views/sensitive_info_section.dart';
import 'package:bikynav/features/users/presentation/views/user_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UpdateUserDataScreen extends StatefulWidget {
  const UpdateUserDataScreen({super.key});

  @override
  State<UpdateUserDataScreen> createState() => _UpdateUserDataScreenState();
}

class _UpdateUserDataScreenState extends State<UpdateUserDataScreen> {
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

    nameController = TextEditingController(text: userData.nombre);
    apellidoController = TextEditingController(text: userData.apellidos);
    passwordController = TextEditingController(text: '');
    confirmPasswordController = TextEditingController(text: '');
    selectedRegion = userData.region;
    selectedComuna = userData.comuna;
  }

  @override
  void dispose() {
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
            actions: [
              IconButton(
                onPressed: () async {
                  _confirmDeleteAccount(context);
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  UserFormSection(
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
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    final userServices = Provider.of<UserServices>(context, listen: false);
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar cuenta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final password = passwordController.text.trim();

                if (password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, ingresa tu contraseña.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                try {
                  await userServices.deleteUser(
                    userServices.usuario.id!,
                    password,
                  );

                  showLoadingMessage(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Usuario eliminado',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  context.push('/');
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error al eliminar la cuenta: $error',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );

                  Navigator.of(context).pop(); // Cerrar el diálogo
                } finally {
                  hideLoadingMessage(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}