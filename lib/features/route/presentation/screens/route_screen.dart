import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/presentation/screens/navegacion_screen.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/features/route/config/models/routes.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
        title: const Text('Recorridos guardados'),
      ),
      body: ListView.builder(
        itemCount: rutas.length,
        itemBuilder: (context, index) {
          BikeRoute route = rutas[index];
          return ListTile(
            trailing: IconButton(
              onPressed: (){
                routeServices.deleteRoute( route.id! );


                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Eliminado correctamente')),
                );
                context.push('/nav');
              }, 
              icon: Icon( Icons.delete)
              ),
            title: Text(route.etiqueta ?? 'Ruta sin nombre'),
            leading: const Icon(Icons.route),
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

              searchBloc.state.history.clear();

              context.push('/nav');

            },
          );
        }
      )
    );
  }
}
