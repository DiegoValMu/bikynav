import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void confirmDeleteAccount(BuildContext context) {
    final userServices = Provider.of<UserServices>(context, listen: false);
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return ZoomIn(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              backgroundColor: Colors.white,
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
                  child: const Text('Eliminar', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        );
      },
    );
  }