import 'dart:convert';

import 'package:bikynav/features/nav/app/blocs/location/location_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/map/map_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/search/search_bloc.dart';
import 'package:bikynav/features/nav/config/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDataDisplay extends StatelessWidget {
  const CustomDataDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);

    final place = searchBloc.state.history;
    String name = '';
    double? distance = 0; 
    double tripDuration = 0;

    List<Feature> features = place;
    if (features.isNotEmpty){
      final dataPlace = features.first;

      name = dataPlace.properties.name;
      distance = dataPlace.properties.distancia;
      final time = (dataPlace.properties.duracion);
      tripDuration = (time! / 60).floorToDouble();
    };
    

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
                padding: const EdgeInsets.only( top: 10),
                child: ListTile(
                  leading: Column(
                    children: [
                      const Icon( Icons.timelapse ),
                      Text(
                        '$tripDuration min', 
                        style: const TextStyle( fontSize: 20 ),
                        ),
                    ],
                  ),
                  title: Column(
                    children: [
                      const Text(
                        'Dirección',
                        style: TextStyle( 
                          fontSize: 20,
                          fontWeight: FontWeight.bold, 
                          ),
                        ),
                      Text(
                        '$name', 
                        style: const TextStyle( fontSize: 20 ),
                      )
                    ]
                  ),
                  trailing: Column(
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
