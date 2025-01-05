import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/shared/services/socket_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/services/user_services.dart';

class SideMenu extends StatelessWidget {
  final bool isMenuOpen;
  final VoidCallback onClose;

  const SideMenu({
    super.key,
    required this.isMenuOpen,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    final userServices = Provider.of<UserServices>(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(isMenuOpen ? 0 : -MediaQuery.of(context).size.width, 0, 0),
      color: Colors.white.withOpacity(0.9),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Container(
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.offline_bolt, color: Colors.red),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Image(
                            image: AssetImage('assets/images/login.png'),
                            height: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('¡Hola, ${userServices.usuario.nombre}!', style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0
                              )),
                              FilledButton(
                                onPressed: () async {
                                  context.push('/perfil');
                                  // Redirige a la pantalla de perfil
                                },
                                child: const Text('Ver perfil'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Divider(),
                    ),
                    const ListTile(
                      leading: Icon(Icons.directions_bike),
                      title: Text('Bicicletas'),
                    ),
                    ListTile(
                      leading: Icon(Icons.route),
                      title: Text('Recorridos'),
                      onTap: () async {
                        // Mostrar el mensaje de carga
                        showLoadingMessage(context);

                        final routeServices = Provider.of<RouteServices>(context, listen: false);
                        final userServices = Provider.of<UserServices>(context, listen: false);

                        // Realizar la operación de carga (por ejemplo, obtener las rutas)
                        await routeServices.getRoutes(userServices.usuario.id!);

                        // Ocultar el mensaje de carga después de la operación
     //                   Navigator.pop(context); // Esto oculta el mensaje de carga si fue implementado con un `showDialog`
                        hideLoadingMessage(context);
                        // Redirigir a la pantalla de recorridos
                        context.push('/route');
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      await FirebaseAuth.instance.currentUser?.reload();
                      context.push('/'); // Redirige a la pantalla de inicio de sesión
                    },
                    child: const Text('Cerrar Sesión'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
