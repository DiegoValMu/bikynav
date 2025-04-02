import 'package:bikynav/features/bikes/app/services/bike_services.dart';
import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/shared/services/socket_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/users/app/services/user_services.dart';

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
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(
          isMenuOpen ? 0 : -MediaQuery.of(context).size.width, 0, 0),
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Icon(
              socketService.serverStatus == ServerStatus.Online
                  ? Icons.check_circle
                  : Icons.offline_bolt,
              color: socketService.serverStatus == ServerStatus.Online
                  ? Colors.green
                  : Colors.red,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildUserProfile(context, userServices),
                    _buildMenuItem(
                      context,
                      'Bicicletas',
                      Icons.directions_bike,
                      '/bikes',
                      'assets/images/1.png',
                      () async {
                        final bikeServices = Provider.of<BikeServices>(context, listen: false);
                        await _loadAndNavigate(context, bikeServices.getBikes(userServices.usuario.id!), '/bikes');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      'Recorridos',
                      Icons.route,
                      '/route',
                      'assets/images/2.png',
                      () async {
                        final routeServices = Provider.of<RouteServices>(context, listen: false);
                        await _loadAndNavigate(  context, routeServices.getRoutes(userServices.usuario.id!), '/route');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      'Normativa',
                      Icons.account_balance_rounded,
                      '/normative',
                      'assets/images/3.png',
                      () async {
                        await _loadAndNavigate(context, Future.value(), '/normative');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      'Tutoriales',
                      Icons.play_arrow_rounded,
                      '/tutorials',
                      'assets/images/4.png',
                      () async {
                        await _loadAndNavigate(context, Future.value(), '/tutorials');
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      onClose();
                      await FirebaseAuth.instance.signOut();
                      await FirebaseAuth.instance.currentUser?.reload();
                      context.push('/');
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

  Widget _buildUserProfile(BuildContext context, UserServices userServices) {
    return Container(
      margin: const EdgeInsets.only( bottom: 10 ),
      padding: const EdgeInsets.only( bottom: 15 ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 5,
            offset: Offset(-2, 0.0),
          )
        ]
      ),
      child: Row(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('¡Hola, ${userServices.usuario.nombre}!',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24.0)),
                FilledButton(
                  onPressed: () => context.push('/perfil'),
                  child: const Text('Ver perfil'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    String route,
    String imagePath,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      alignment: Alignment.center,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            offset: Offset(-2, 0),
            blurRadius: 5,
          ),
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> _loadAndNavigate(BuildContext context, Future<void> loadAction, String route) async {
    showLoadingMessage(context);
    await loadAction;
    hideLoadingMessage(context);
    context.push(route);
  }
}