import 'package:bikynav/features/nav/app/blocs/map/map_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/search/search_bloc.dart';
import 'package:bikynav/features/nav/config/models/models.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/features/route/presentation/widgets/btn_save_route.dart';
import 'package:bikynav/features/route/app/helpers/real_time_provider.dart';
import 'package:bikynav/shared/views/custom_draggable_sheet.dart';
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
            leading: Column(
              children: [
                const Icon(Icons.timelapse),
                (mapBloc.state.showMyRoute)
                    ? Text('$minutes:$displaySeconds', style: const TextStyle(fontSize: 18))
                    : Text(
                        '$tripDuration min', 
                        style: const TextStyle(fontSize: 16),
                      ),
              ],
            ),
            title: (mapBloc.state.showMyRoute)
                ? const BtnSaveRoute()
                : Column(
                    children: [
                      (mapBloc.state.onSelectRoute)
                          ? const Text('Ruta',
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
                        textAlign: TextAlign.center,
                      )
                    ]
                  ),
            trailing: (mapBloc.state.showMyRoute)
            ? const Text('')
            : Column(
              children: [
                const Icon(Icons.directions_bike),
                Text(
                  '$distance kms',
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Divider(),
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