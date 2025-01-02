import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:bikynav/features/nav/app/blocs/location/location_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/map/map_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/search/search_bloc.dart';
import 'package:bikynav/features/nav/config/models/models.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/features/route/presentation/widgets/btn_save_route.dart';
import 'package:bikynav/features/route/app/helpers/real_time_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DataRouteDisplay extends StatefulWidget {
  const DataRouteDisplay({super.key});

  @override
  State<DataRouteDisplay> createState() => _DataRouteDisplayState();
}

class _DataRouteDisplayState extends State<DataRouteDisplay> {
  @override
  void initState() {
    super.initState();
    // Iniciar el cronómetro cuando se muestre la pantalla
    Provider.of<StopwatchProvider>(context, listen: false).startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);



    String name = '';
    double distance = 0; 
    double tripDuration = 0;

  
    return SafeArea(
      bottom: true,
      child: Container(
        height: 100, // Altura fija
        decoration: BoxDecoration(
          color: Colors.white, // Color de fondo
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20), // Bordes redondeados en la parte superior
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Color de sombra
              spreadRadius: 2, // Expansión de la sombra
              blurRadius: 8, // Desenfoque de la sombra
              offset: const Offset(0, -2), // Sombra hacia arriba
            ),
          ],
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only( top: 5),
                child: Container(
                  height: 5, // Altura de la barra decorativa
                  width: 40, // Anchura de la barra decorativa
                  decoration: BoxDecoration(
                    color: Colors.grey[400], // Color de la barra decorativa
                    borderRadius: BorderRadius.circular(10), // Bordes redondeados
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only( top: 5),
                child: ListTile(
                  leading: Column(
                    children: [
                      const Icon( Icons.timelapse ),
                      (mapBloc.state.showMyRoute)
                      ? Text('', style: TextStyle( fontSize: 20 ),)
                      : Text(
                        '$tripDuration min', 
                        style: const TextStyle( fontSize: 20 ),
                        ),
                    ],
                  ),
                  title: (mapBloc.state.showMyRoute)
                  ? BtnSaveRoute()
                  : Column(
                    children: [
                      const Text(
                        'Dirección',
                        style: TextStyle( 
                          fontSize: 20,
                          fontWeight: FontWeight.bold, 
                          ),
                        ),
                      Text(
                        name, 
                        style: const TextStyle( fontSize: 20 ),
                      )
                    ]
                  ),
                  trailing: 
                    ( mapBloc.state.showMyRoute )
                    ? const Text('')
                    : Column(
                    children: [
                      const Icon( Icons.directions_bike ),
                      Text(
                        '$distance kms',
                        style: const TextStyle( fontSize: 20 ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
