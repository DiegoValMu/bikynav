import 'dart:convert';

import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/features/route/config/models/routes.dart';
import 'package:bikynav/features/route/config/models/routesById.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../app/utils/id_utils.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    final routeServices = Provider.of<RouteServices>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    List<BikeRoute> rutas = routeServices.rutas.map<BikeRoute>((ruta) {
      if (ruta is Map<String, dynamic>) {
        return BikeRoute.fromJson(ruta);
      } else if (ruta is BikeRoute) {
        return ruta;
      } else {
        throw TypeError(); // Manejo de casos no esperados
      }
    }).toList();

    // Simulamos las respuestas recibida

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight), // Altura estándar del AppBar
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Fondo blanco para el AppBar
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Color de la sombra
                offset: const Offset(0, 4), // Sombra hacia abajo
                blurRadius: 6, // Difusión de la sombra
              ),
            ],
          ),
          child: AppBar(
            title: const Text('Recorridos'),
            elevation: 0, // Sin sombra por elevación
            backgroundColor: Colors.transparent, // Fondo transparente para el AppBar
            centerTitle: true, // Centrar el título
            actions: [
              IconButton(
                onPressed: (){
                  _inputRoute(context);
                  
                },
                icon: Icon( Icons.link),
                )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only( top: 8),
        child: ListView.builder(
          itemCount: rutas.length,
          itemBuilder: (context, index) {
            BikeRoute route = rutas[index];
            final time = route.tiempoUtilizado!.toDouble();
            final tripDuration = (time! / 60).toStringAsFixed(2);
            final kms = route.distancia;
            final distance = (kms! * 10).roundToDouble() / 10;

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white, // Fondo blanco
                    borderRadius: BorderRadius.circular(10), // Bordes redondeados opcionales
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Color de la sombra
                        blurRadius: 10, // Difuminado de la sombra
                        offset: const Offset(0, 5), // Desplazamiento de la sombra
                      ),
                    ],
                  ),
                  child: ListTile(
                    trailing: IconButton(
                      onPressed: (){
                        routeServices.deleteRoute( route.id! );
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Eliminado correctamente')),
                        );
                        context.push('/nav');
                      }, 
                      
                      icon: const Icon( 
                        Icons.delete,
                        color: Colors.red,
                        )
                      ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Text('Duración: ${tripDuration} minutos'),
                        Text('Distancia: ${distance} kms'),
                        const SizedBox(height: 10),
                      ],
                    ),
                    title: Text(route.etiqueta ?? 'Ruta sin nombre', style: const TextStyle( fontWeight: FontWeight.bold),),
                    
                    leading: IconButton(
                      onPressed: (){                          
                        // Camuflar el ID
                        String idCamuflado = camuflarID(route.id!);

                        // Generar un enlace con el ID camuflado
                        String dynamicLink = generarDynamicLink(idCamuflado);

                        // Copiar el enlace al portapapeles
                        Clipboard.setData(ClipboardData(text: dynamicLink));

                        // Mostrar un mensaje al usuario
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text("Codigo copiado al portapapeles, comparta a otros usuarios para acceder al recorrido seleccionado")),
                        );
                      }, 
                      icon: const Icon( 
                        Icons.share,
                        color: Colors.green,
                        )
                      ),
                    onTap: () async {
                  
                      final startMarker = Marker(
                        markerId: const MarkerId('start'),
                        position: route.ubicacionInicial!,
                        infoWindow: const InfoWindow(
                          title: 'Ubicación inicial',
                        )
                      );
                  
                      final endMarker = Marker(
                        markerId: const MarkerId('end'),
                        position: route.ubicacionFinal!,
                        infoWindow: InfoWindow(
                          title: 'Destino',
                          snippet: route.etiqueta
                        )
                      );
                  
                      final currentPolylines = Map<String, Polyline>.from( mapBloc.state.polylines );
                      final points = route.ruta!['myRoute']?.points;
                  
                      final myRoute = Polyline(
                        polylineId: const PolylineId('route'),
                        color: Colors.black,
                        width: 5,
                        points: points!,
                        startCap: Cap.roundCap,
                        endCap: Cap.roundCap
                      );
                      
                      final currentMarkers = Map<String, Marker>.from( mapBloc.state.markers );
                      currentMarkers['start'] = startMarker;
                      currentMarkers['end'] = endMarker;
                  
                      currentPolylines['route'] = myRoute;      
                  
                      mapBloc.add( DisplayPolylinesEvent( currentPolylines , currentMarkers) );
                      mapBloc.add( OnInitRoute() );
                  
                      routeServices.myRoute = route;
                  
                      // Acción al seleccionar una ruta
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Seleccionaste ${route.etiqueta ?? "una ruta"}')),
                      );
                  
                      searchBloc.state.copyWith( history: const []);
                  
                      context.push('/nav');
                  
                    },
                    
                  ),
                ),
                const Divider(),  
              ],
            );
          }
        ),
      )
    );
  }

  Future<dynamic> _inputRoute(BuildContext context) {
  final routeServices = Provider.of<RouteServices>(context, listen: false);
  final TextEditingController idController = TextEditingController();
  final mapBloc = BlocProvider.of<MapBloc>(context);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ingresar ruta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ingrese el codigo para acceder a la ruta.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'Codigo',
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
            FilledButton(
              onPressed: () async {

                final idEncode = idController.text.trim();

                if (idEncode.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, ingresa un codigo.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                try {

                  final idRoute = decodificarID(idController.text);

                  //final routeResponse = await routeServices.getRouteById(idRoute);
//
                  //BikeRoute routeById = jsonDecode(routeResponse);

                  Ruta routeById = await routeServices.getRouteById(idRoute);

                  final startMarker = Marker(
                    markerId: const MarkerId('start'),
                    position: routeById.ubicacionInicial!,
                    infoWindow: const InfoWindow(
                      title: 'Ubicación inicial',
                    )
                  );
              
                  final endMarker = Marker(
                    markerId: const MarkerId('end'),
                    position: routeById.ubicacionFinal!,
                    infoWindow: InfoWindow(
                      title: 'Destino',
                      snippet: routeById.etiqueta
                    )
                  );
              
                  final currentPolylines = Map<String, Polyline>.from( mapBloc.state.polylines );
                  final points = routeById.rutaDetalles.points;
              
                  final myRoute = Polyline(
                    polylineId: const PolylineId('route'),
                    color: Colors.black,
                    width: 5,
                    points: points!,
                    startCap: Cap.roundCap,
                    endCap: Cap.roundCap
                  );
                  
                  final currentMarkers = Map<String, Marker>.from( mapBloc.state.markers );
                  currentMarkers['start'] = startMarker;
                  currentMarkers['end'] = endMarker;
              
                  currentPolylines['route'] = myRoute;      
              
                  mapBloc.add( DisplayPolylinesEvent( currentPolylines , currentMarkers) );
                  mapBloc.add( OnInitRoute() );
              
                  routeServices.myRoute.etiqueta = routeById.etiqueta;
                  routeServices.myRoute.distancia = routeById.calcularDistancia();
                  routeServices.myRoute.tiempoUtilizado = routeById.tiempo;
              
                  // Acción al seleccionar una ruta
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Seleccionaste ${routeById.etiqueta ?? "una ruta"}')),
                  );
              
                  context.push('/nav');

                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error al ingresar la ruta: $error',
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
              child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
