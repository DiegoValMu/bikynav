import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/nav/presentation/screens/navegacion_screen.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userServices = Provider.of<UserServices>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Altura estándar del AppBar
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Fondo blanco para el AppBar
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Color de la sombra
                offset: Offset(0, 4), // Sombra hacia abajo
                blurRadius: 6, // Difusión de la sombra
              ),
            ],
          ),
          child: AppBar(
            title: const Text('Perfil'),
            elevation: 0, // Sin sombra por elevación
            backgroundColor: Colors.transparent, // Fondo transparente para el AppBar
            centerTitle: true, // Centrar el título
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar y nombre
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    '${userServices.usuario.nombre} ${userServices.usuario.apellidos}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    userServices.usuario.email!,
                    style: const TextStyle( fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  
                ],
              ),
            ),
            

            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white, // Fondo blanco
                borderRadius: BorderRadius.circular(10), // Bordes redondeados opcionales
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Color de la sombra
                    blurRadius: 10, // Difuminado de la sombra
                    offset: Offset(0, 5), // Desplazamiento de la sombra
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10), // Margen externo opcional
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Información básica',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          context.push('/update_perfil');
                          // Lógica para editar perfil
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100, // Ajusta este valor según la cantidad de contenido
                    child: ListView(
                      children: [
                        _buildInfoRow('Comuna', '${userServices.usuario.comuna}'),
                        _buildInfoRow('Región', '${userServices.usuario.region}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),


            // Botón eliminar cuenta
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  
                  _confirmDeleteAccount(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Eliminar cuenta', style: TextStyle( color: Colors.white ),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    final userServices = Provider.of<UserServices>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar cuenta'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                 // Cerrar el diálogo

                User? user = FirebaseAuth.instance.currentUser;

                await user?.delete();

                await userServices.deleteUser( userServices.usuario.id! );

                showLoadingMessage(context);
                const SnackBar(
                          content: Text('Usuario eliminado', style: TextStyle( color: Colors.white),),
                          backgroundColor: Colors.red, 
                );
                  // Lógica para eliminar cuenta
                
                context.push('/');

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Eliminar', style: TextStyle( color: Colors.white )),
            ),
          ],
        );
      },
    );
  }
}
