import 'package:bikynav/app/blocs/map/map_bloc.dart';
import 'package:bikynav/app/services/route_service.dart';
import 'package:bikynav/config/models/places_models.dart';
import 'package:bikynav/presentation/shared/views/custom_draggable_sheet.dart';
import 'package:bikynav/presentation/shared/views/display_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../Navegacion/widgets/widgets.dart';

class RouteDisplay extends CustomDraggableSheet {
  
  RouteDisplay({super.key}) : super(
    minHeight: 100,
    maxHeight: 450,
    child: const _RouteDisplayContent(),
  );
}

class _RouteDisplayContent extends StatefulWidget {

  const _RouteDisplayContent();

  @override
  State<_RouteDisplayContent> createState() => _RouteDisplayContentState();
}

class _RouteDisplayContentState extends State<_RouteDisplayContent> {
  @override
  Widget build(BuildContext context) {
    final routeServices = Provider.of<RouteServices>(context);
    

    final name = routeServices.myRoute.etiqueta!;
    final kms = routeServices.myRoute.distancia!;

    final distance = (kms * 10).roundToDouble() / 10;
    final tripDuration = (routeServices.myRoute.tiempoUtilizado! / 60).floorToDouble();

    final startPlace = routeServices.infoStartPlace!;
    final endPlace = routeServices.infoEndPlace!;

    final directions = routeServices.directions;

    var distanceToStart = directions!.distance.roundToDouble() / 10;
    String longitud = 'kms';

    if(distanceToStart <= 1.0 ){
      distanceToStart *= 1000;
      longitud = 'metros';
    }

    return Column(
      children: [
        const DecorativeBar(),
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: buildTitle(tripDuration, distance, name, true),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const Text('Detalles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  _infoRoute(tripDuration),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        const Text('Inicio: ', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16),),
                        Text('(a $distanceToStart $longitud de distancia)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.left,)
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  buildStartEnd(startPlace, true),
                  const Text('Fin:', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16),),
                  const SizedBox(height: 5,),
                  buildStartEnd(endPlace, false),
                  const SizedBox(height: 5,),
                  const Divider()
                ],
              ),
            ),
          )
        )
        // ... resto del contenido específico para rutas
      ],
    );
  }

  Widget _infoRoute(double time) { 
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5)
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tiempo Utilizado: $time min', style: const TextStyle(fontSize: 12),),
              Text('Velocidad promedio: $time km/hr', style: const TextStyle(fontSize: 12),),
              Text('Velocidad maxima: $time km/hr', style: const TextStyle(fontSize: 12),),
              const Text('Bicicleta utilizada: ', style: TextStyle(fontSize: 12),)
            ],
          ),
          
        ],
      ),
    );
  }

  Container buildStartEnd(Feature place, bool start) {
    String formattedLocation = place.properties.placeFormatted;
    formattedLocation = formattedLocation.replaceAll(RegExp(r'\s*\d{7}(?=,)'), '');
    formattedLocation = formattedLocation.split(',').take(2).join(',');

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5)
      ),
      height: 70,
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${place.properties.name}', style: const TextStyle( fontSize: 14)),
                Text(formattedLocation, style: const TextStyle( fontSize: 12)),
                Text(
                  '(${place.properties.coordinates.latitude}° S, ${place.properties.coordinates.longitude}° O)',
                  style: const TextStyle( fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const Spacer(),
          
          PopupMenuButton(
            color: Colors.white,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem(
                value: 'indicaciones',
                child: Row(
                  children: [
                    Icon(Icons.directions, size: 28,),
                    Text(' Como llegar', style: TextStyle( fontSize: 14),)
                  ],
                )
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'copiar',
                child: Row(
                  children: [
                    Icon(Icons.copy, size: 28,),
                    Text(' Copiar datos', style: TextStyle( fontSize: 14),)
                  ],
                )
              ),
            ] 
          )
        ],
      ),
    );
  }


}