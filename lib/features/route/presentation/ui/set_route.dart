import 'package:animate_do/animate_do.dart';
import 'package:bikynav/features/nav/app/blocs/map/map_bloc.dart';
import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/features/route/app/utils/id_utils.dart';
import 'package:bikynav/features/route/config/models/routesById.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

Future<void> inputRoute(BuildContext context) {
    final routeServices = Provider.of<RouteServices>(context, listen: false);
    final TextEditingController idController = TextEditingController();
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return showDialog(
      context: context,
      builder: (context) {
        return ZoomIn(
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Ingresar ruta'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ingrese el código para acceder a la ruta.'),
                const SizedBox(height: 16),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'Código',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  final idEncode = idController.text.trim();

                  if (idEncode.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, ingresa un código.')));
                    return;
                  }

                  try {
                    final idRoute = decodificarID(idController.text);
                    Ruta routeById = await routeServices.getRouteById(idRoute);

                    final startMarker = Marker(
                      markerId: const MarkerId('start'),
                      position: routeById.ubicacionInicial,
                      infoWindow: const InfoWindow(title: 'Ubicación inicial'),
                    );

                    final endMarker = Marker(
                      markerId: const MarkerId('end'),
                      position: routeById.ubicacionFinal,
                      infoWindow: InfoWindow(title: 'Destino', snippet: routeById.etiqueta),
                    );

                    final currentPolylines = Map<String, Polyline>.from(mapBloc.state.polylines);
                    final points = routeById.rutaDetalles.points;
                    final myRoute = Polyline(
                      polylineId: const PolylineId('route'),
                      color: Colors.black,
                      width: 5,
                      points: points,
                      startCap: Cap.roundCap,
                      endCap: Cap.roundCap,
                    );

                    final currentMarkers = Map<String, Marker>.from(mapBloc.state.markers);
                    currentMarkers['start'] = startMarker;
                    currentMarkers['end'] = endMarker;
                    currentPolylines['route'] = myRoute;

                    mapBloc.add(DisplayPolylinesEvent(currentPolylines, currentMarkers));
                    mapBloc.add(OnInitRoute());

                    routeServices.myRoute.etiqueta = routeById.etiqueta;
                    routeServices.myRoute.distancia = routeById.calcularDistancia();
                    routeServices.myRoute.tiempoUtilizado = routeById.tiempo;

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Seleccionaste ${routeById.etiqueta}')));
                    context.push('/nav');
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al ingresar la ruta: $error')));
                    Navigator.of(context).pop();
                  } finally {
                    hideLoadingMessage(context);
                  }
                },
                child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }