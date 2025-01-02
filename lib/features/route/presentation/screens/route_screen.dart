import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  
  @override
  Widget build(BuildContext context) {

    final userServices = Provider.of<UserServices>(context);  
    final routeServices = Provider.of<RouteServices>(context);

    // Simulamos las respuestas recibida

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorridos guardados'),
      ),
      body: ListView.builder(
        itemCount: routeServices.rutas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(''),
            leading: const Icon(Icons.route),
            onTap: () async {

              
              //ScaffoldMessenger.of(context).showSnackBar(
              //  SnackBar(content: Text('You selected ${responses[index]}')),
              //);
            },
          );
        },
      ),
    );
  }
}
