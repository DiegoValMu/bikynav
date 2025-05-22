
import 'package:bikynav/app/services/user_services.dart';
import 'package:bikynav/presentation/shared/widgets/custom_build_info_row.dart';
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
        preferredSize: const Size.fromHeight(kToolbarHeight), // Altura estándar del AppBar
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white, // Fondo blanco para el AppBar
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2), // Color de la sombra
                offset: Offset(0, 4), // Sombra hacia abajo
                blurRadius: 6, // Difusión de la sombra
              ),
            ],
          ),
          child: AppBar(
            title: const Text('Perfil'),
            elevation: 0, // Sin sombra por elevación
            backgroundColor: Colors.transparent, // Fondo transparente para el AppBar
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/update_perfil');
                  // Lógica para editar perfil
                },
                icon: const Icon(Icons.edit),
              )
            ], // Centrar el título
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage( 'assets/images/banner.png' ), // Si es desde una URL
                  fit: BoxFit.cover, // Esto asegura que la imagen cubra todo el fondo
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    '${userServices.usuario.nombre} ${userServices.usuario.apellidos}',
                    style: const TextStyle(fontSize: 24, color: Colors.white), // Color blanco para el texto
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
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2), // Color de la sombra
                    blurRadius: 8, // Difuminado de la sombra
                    offset: Offset(0, 2), // Desplazamiento de la sombra
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10), // Margen externo opcional
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    ExpansionTile(
                      title: const Text(
                        'Información basica',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      initiallyExpanded: true,
                      maintainState: true,
                      tilePadding: EdgeInsets.zero, // Quita el padding del encabezado
                      childrenPadding: EdgeInsets.zero, // Elimina el padding extra de los hijos
                      collapsedBackgroundColor: Colors.white, // Asegura el fondo blanco cerrado
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                      collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                      children: [ 
                        Column(
                          children: [
                            const Divider(),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 100, // Ajusta este valor según la cantidad de contenido
                              child: ListView(
                                children: [
                                  buildInfoRow('Correo', '${userServices.usuario.email}'),
                                  buildInfoRow('Comuna', '${userServices.usuario.comuna}'),
                                  buildInfoRow('Región', '${userServices.usuario.region}'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ]
                    ),
                ],
              ),
            ),
            // Botón eliminar cuenta
          ],
        ),
      ),
    );
  }

  

  

}
