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

    List<Feature> features = place;
    final dataPlace = features[0];

    final data = dataPlace.properties.name;



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
              ListTile(
                title: Text('$data'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
