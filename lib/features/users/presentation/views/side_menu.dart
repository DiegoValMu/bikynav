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
            leading: 
              Container(
                child: (socketService.serverStatus == ServerStatus.Online )
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.offline_bolt, color: Colors.red,),
              )
            ,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: ListView(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only( left: 10 ),
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
                        Text('¡Hola, ${userServices.usuario.nombre}!', style: 
                          const TextStyle( 
                            fontWeight: FontWeight.bold, 
                            fontSize: 24.0
                            )),
                        FilledButton(
                          onPressed: () async {
                                // Redirige a la pantalla de inicio de sesión
                              },
                          child: const Text('Ver perfil')
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ),
              Padding(
                padding: const EdgeInsets.only( top: 10 ),
                child: Divider(),
              ),
              const ListTile(title: Text('Opción 1')),
              const ListTile(title: Text('Opción 2')),

              FilledButton(
                onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      await FirebaseAuth.instance.currentUser?.reload();
                      context.push('/'); // Redirige a la pantalla de inicio de sesión
                    },
                child: const Icon( Icons.logout)),
              // Agrega más opciones aquí
            ],
          ),
        ),
      ),
    );
  }
}