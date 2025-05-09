import 'package:bikynav/app/blocs/blocs.dart';
import 'package:bikynav/app/blocs/map/map_bloc.dart';
import 'package:bikynav/app/blocs/search/search_bloc.dart';
import 'package:bikynav/app/helpers/show_loading_message.dart';
import 'package:bikynav/config/models/models.dart';
import 'package:bikynav/app/services/route_service.dart';
import 'package:bikynav/presentation/Rutas/ui/nav_route_options.dart';
import 'package:bikynav/presentation/Rutas/widgets/btn_save_route.dart';
import 'package:bikynav/app/helpers/real_time_provider.dart';
import 'package:bikynav/presentation/shared/views/custom_draggable_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CustomDataDisplay extends CustomDraggableSheet {
  final id;
  
  CustomDataDisplay({super.key, this.id}) : super(
    minHeight: 100,
    maxHeight: 450,
    child: _CustomDataDisplayContent(id: id),
  );
}

class _CustomDataDisplayContent extends StatefulWidget {
  final id;
  const _CustomDataDisplayContent({this.id});

  @override
  State<_CustomDataDisplayContent> createState() => _CustomDataDisplayContentState();
}

class _CustomDataDisplayContentState extends State<_CustomDataDisplayContent> {
  @override
  void initState() {
    super.initState();
    // Iniciar el cronómetro cuando se muestre la pantalla
    Provider.of<StopwatchProvider>(context, listen: false).startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final routeServices = Provider.of<RouteServices>(context);

    final stopwatchProvider = Provider.of<StopwatchProvider>(context);
    final int seconds = stopwatchProvider.elapsedSeconds;

    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final displaySeconds = (seconds % 60).toString().padLeft(2, '0');

    final place = searchBloc.state.history;
    String name = '';
    double? distance; 
    double? tripDuration;
    double? kms;

    List<Feature> features = place;
    if (features.isNotEmpty && mapBloc.state.onInitRoute){
      routeServices.selectNavRoute;
      final dataPlace = features.firstWhere(
        (feature) => feature.id == routeServices.selectNavRoute,
        orElse: () => features.first, // Fallback si no encuentra coincidencia
      );

      name = dataPlace.properties.name;
      distance = dataPlace.properties.distancia ?? 00;
      final time = (dataPlace.properties.duracion) ?? 00;
      tripDuration = (time / 60).floorToDouble();

    }

    if ( routeServices.rutas.isNotEmpty && mapBloc.state.onSelectRoute && !mapBloc.state.onInitRoute){
      name = routeServices.myRoute.etiqueta!;
      kms = routeServices.myRoute.distancia!;
      distance = (kms * 10).roundToDouble() / 10;
      final time = (routeServices.myRoute.tiempoUtilizado);
      tripDuration = (time! / 60).floorToDouble();
      
    } 

    return Column(
      children: [
        const DecorativeBar(),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ListTile(
            leading: SizedBox(  // Usamos SizedBox para controlar el ancho del leading
              width: 80,      // Ajusta este valor según necesidad
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [
                  // Fila para el tiempo (icono + texto)
                  Row(
                    children: [
                      const Icon(Icons.timelapse, size: 15),
                      const SizedBox(width: 3),
                      (mapBloc.state.showMyRoute)
                          ? Text(
                              '$minutes:$displaySeconds',
                              style: const TextStyle(fontSize: 12),
                            )
                          : Text(
                              '$tripDuration min',
                              style: const TextStyle(fontSize: 12),
                            ),
                    ],
                  ),
                  const SizedBox(height: 4), // Espacio entre tiempo y distancia
                  // Fila para la distancia (icono + texto)
                  Row(
                    children: [
                      const Icon(Icons.flag, size: 15),
                      const SizedBox(width: 8),
                      Text(
                        '$distance km',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            title: (mapBloc.state.showMyRoute)
                ? const BtnSaveRoute() // Botón guardar (sin cambios)
                : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (mapBloc.state.onSelectRoute)
                          ? const Text(
                              'Ruta',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text(
                              'Dirección',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
            trailing: IconButton(
              icon: const Icon(Icons.close, size: 24),
              onPressed: () {
                mapBloc.add( OnCancelRoute() );
                mapBloc.state.polylines.remove('myRoute');
                mapBloc.state.polylines.remove('route');
                mapBloc.state.markers.remove('start');
                mapBloc.state.markers.remove('end');
                // Lógica del botón close
              },
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                const Divider(), 
                NavRouteOptions(
                  locationBloc: locationBloc, 
                  routeServices: routeServices, 
                  searchBloc: searchBloc, 
                  mapBloc: mapBloc
                ),
                
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DecorativeBar extends StatelessWidget {
  const DecorativeBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Center(
        child: Container(
          height: 5,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}