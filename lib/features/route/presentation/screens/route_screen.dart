
import 'package:bikynav/features/bikes/app/helpers/generate_qr_code.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/features/route/config/models/routes.dart';
import 'package:bikynav/features/route/presentation/ui/set_route.dart';
import 'package:bikynav/features/route/presentation/views/build_route.dart';
import 'package:bikynav/shared/ui/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/utils/id_utils.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeServices = Provider.of<RouteServices>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    List<BikeRoute> rutas = _getBikeRoutes(routeServices.rutas);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white, // Fondo blanco para el AppBar
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2), // Color de la sombra
                offset: Offset(0, 0), // Sombra hacia abajo
                blurRadius: 1, // Difusión de la sombra
                blurStyle: BlurStyle.normal
              ),
            ],
          ),
          child: _buildAppBar(context)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView.builder(
          itemCount: rutas.length,
          itemBuilder: (context, index) {
            BikeRoute route = rutas[index];
            return _buildRouteListTile(context, route, mapBloc, routeServices);
          },
        ),
      ),
      bottomNavigationBar: BuildBottomNavigationBar(items: [
        BottomNavigationBarItemData(
          icon: Icons.search,
          label: 'Buscar',
          onPressed: () => context.push('/search_route'),
        ),
        BottomNavigationBarItemData(
          icon: Icons.qr_code_scanner,
          label: 'Escanear QR',
          onPressed: () => context.push('/scanner_qr'),
        ),
        BottomNavigationBarItemData(
          icon: Icons.ios_share_outlined,
          label: 'Codigo Ruta',
          onPressed: () => inputRoute(context), // Asegúrate de que _inputRoute esté accesible o pásala si es necesario
        ),
      ],),
    );
  }

  List<BikeRoute> _getBikeRoutes(List<dynamic> rutasData) {
    return rutasData.map<BikeRoute>((ruta) {
      if (ruta is Map<String, dynamic>) {
        return BikeRoute.fromJson(ruta);
      } else if (ruta is BikeRoute) {
        return ruta;
      } else {
        return BikeRoute(); // Devuelve una ruta vacía si no es del tipo esperado
      }
    }).toList();
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Recorridos'),
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
    );
  }

  Widget _buildRouteListTile(BuildContext context, BikeRoute route, MapBloc mapBloc, RouteServices routeServices) {
    final time = route.tiempoUtilizado!.toDouble();
    final tripDuration = (time / 60).toStringAsFixed(2);
    final kms = route.distancia;
    final distance = (kms! * 10).roundToDouble() / 10;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only( top: 15),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 1,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: ListTile(
            trailing: IconButton(
              onPressed: () => _shareRoute(context, route),
              icon: const Icon(Icons.share, color: Colors.green),
            ),
            contentPadding: const EdgeInsets.only( top: 10 ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Text('Duración: $tripDuration minutos'),
                Text('Distancia: $distance kms'),
                const SizedBox(height: 10),
              ],
            ),
            title: Text(route.etiqueta ?? 'Ruta sin nombre', style: const TextStyle(fontWeight: FontWeight.bold)),
            leading: IconButton(
              onPressed: () {
                _deleteRoute(context, route.id!, routeServices);
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
            onTap: () => onRouteTap(context, route, mapBloc, routeServices),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteRoute(BuildContext context, String routeId, RouteServices routeServices) async {
    routeServices.deleteRoute(routeId);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Eliminado correctamente')));
    context.push('/nav');
  }

  Future<void> _shareRoute(BuildContext context, BikeRoute route) async {
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Compartir Ruta ${route.etiqueta}'),
          actions: [
            FilledButton.icon(
              onPressed: (){
                generateQRCode(context, route.id, 'route');
              }, 
              label: const Text('Generar QR'),
            ),
            FilledButton.icon(
              onPressed: () async {
                String idCamuflado = camuflarID(route.id!);
                String dynamicLink = generarDynamicLink(idCamuflado);
                await Clipboard.setData(ClipboardData(text: dynamicLink));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Código copiado al portapapeles", 
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  )
                );
              }, 
              label: const Text('Generar codigo'),
            )
          ],
        );
      }
      );



    
  }

  
}
