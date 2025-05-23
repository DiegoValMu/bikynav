import 'package:bikynav/app/blocs/blocs.dart';
import 'package:bikynav/app/services/route_service.dart';
import 'package:bikynav/config/models/models.dart';
import 'package:bikynav/presentation/shared/views/custom_draggable_sheet.dart';
import 'package:bikynav/presentation/shared/views/display_titles.dart';
import 'package:bikynav/presentation/shared/widgets/decorative_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';


class DirectionDisplay extends CustomDraggableSheet {

  
  DirectionDisplay({super.key}) : super(
    minHeight: 100,
    maxHeight: 450,
    child: const _DirectionDisplayContent(),
  );
}

class _DirectionDisplayContent extends StatefulWidget {
  const _DirectionDisplayContent();

  @override
  State<_DirectionDisplayContent> createState() => _DirectionDisplayContentState();
}

class _DirectionDisplayContentState extends State<_DirectionDisplayContent> {

  String formatearDireccion(String nombre) {
    // Elimina espacios en blanco al inicio y final
    final nombreLimpio = nombre.trim();

    // Verifica si el primer carácter es un número
    if (nombreLimpio.isNotEmpty && nombreLimpio[0].contains(RegExp(r'[0-9]'))) {
      return 'Calle $nombreLimpio'; // o 'Pasaje $nombreLimpio'
    }
    return nombreLimpio; // Retorna el original si no empieza con número
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final routeServices = Provider.of<RouteServices>(context);

    final initPlace = routeServices.infoStartPlace;

    final routes = searchBloc.state.alternativeRoutes;

    final feature = searchBloc.state.history.firstWhere(
      (f) => f.id == routeServices.selectNavRoute,
      orElse: () => searchBloc.state.history.first,
    );

    final direccion = feature.properties.name;
    final name = formatearDireccion(direccion);

    final kms = feature.properties.distancia ?? 0;
    final distance = (kms * 10).roundToDouble() / 10;

    final tripDuration = (feature.properties.duracion ?? 0) / 60;
    final duration = double.parse(tripDuration.toStringAsFixed(2)).roundToDouble();

    return Column(
      children: [
        const DecorativeBar(),
        Padding(
          padding: EdgeInsets.zero,
          child: buildTitle(duration, distance, name, false),
        ),
        const Divider(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _infoDirection(initPlace!, duration),
                _alternativeRoutes(routes)
              ],
            ))
        ),
        
        // ... resto del contenido específico para direcciones
      ],
    );
  }

  SingleChildScrollView _infoDirection(Feature initPlace, double duration) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: SizedBox(
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer_outlined, size: 16,),
                  const Text('Tiempo aproximado ', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                  
                  Text(': $duration min', style: const TextStyle(fontSize: 12),)
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 5, top: 5),
                child: Text('Desde:', textAlign: TextAlign.left, style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: screenWidth - 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey[200]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pin_drop_outlined,),
                      const SizedBox(width: 8,),
                      Text('${initPlace.properties.name}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              const Divider(),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _alternativeRoutes(List<dynamic> routes) {
    final filteredRoutes = routes.sublist(1);

    if(filteredRoutes.isEmpty){
      return const Text('Sin Rutas Alternativas');
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0,),
            child: Text('Rutas alternativas:', textAlign: TextAlign.left, style: TextStyle( fontWeight: FontWeight.bold),),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: filteredRoutes.length,
            itemBuilder: (context, index) {
              final kms = filteredRoutes[index].distance;  
              final distance = double.parse((kms/1000).toStringAsFixed(2)).roundToDouble();

              final tripDuration = filteredRoutes[index].duration / 60;
              final duration = double.parse(tripDuration.toStringAsFixed(2)).roundToDouble();
              
              return  Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.chevron_right),
                    Text('Opción ${index + 2}', style: const TextStyle(fontSize: 18),),
                    const Spacer(),
                    Column(
                      children: [
                        const Icon(Icons.timer_outlined, size: 15),
                        Text('$duration min', style: const TextStyle(fontSize: 12),),
                      ],
                    ),
                    const SizedBox(width: 10,),
                    Column(
                      children: [
                        const Icon(Icons.flag, size: 15),
                        Text('$distance kms', style: const TextStyle(fontSize: 12),),
                      ],
                    ),
                  ],
                ),
              );
            }
          ),
        ],
      ),
    ); 
  } 
  
}