import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/presentation/ui/ui.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {

    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return CircleAvatar(
      maxRadius: 25,
      child: IconButton(
        icon: const Icon( Icons.my_location_outlined),
        onPressed: () {
          final userLocation = locationBloc.state.lastKnowlocation;
          if( userLocation == null ){
            final snack = CustomSnackbar(message: 'no hay ubicacion');
            ScaffoldMessenger.of(context).showSnackBar(snack);
            return;
          } 
          mapBloc.moveCamera(userLocation);
        } 
      ),
    );
  }
}