import 'package:bikynav/features/nav/presentation/screens/navegacion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';

class BtnToggleUserRoute extends StatelessWidget {
  const BtnToggleUserRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    final position = locationBloc.state.lastKnowlocation;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.route), // Icono que representa la acción
        title: const Text('Trazar ruta'), // Título
        onTap: () {
          mapBloc.add(OnToggleUserRoute());
          locationBloc.add( OnNewRouteEvent(position!));
          mapBloc.add(OnInitRoute());

        },
      ),
    );
  }
}
