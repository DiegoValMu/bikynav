import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikynav/app/blocs/blocs.dart';

class BtnCameraUser extends StatelessWidget {

  const BtnCameraUser({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final currentRoute = mapBloc.state.currentRoute;
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return (state.is45DegreeView)
        ? OutlinedButton.icon(
            icon: const Icon(
              Icons.directions_bike,
              color: Colors.blueGrey,),
            onPressed: () {
              mapBloc.add(OnStopFollowingUserEvent());
            },
            label: const Text('Vista completa'),
            style: const ButtonStyle(
              minimumSize: WidgetStatePropertyAll(Size(155, 45)),
              backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(255, 255, 255, 0.8),)
            )
          )
        : FilledButton.icon(
            onPressed: (){

              mapBloc.add(OnStartFollowingUserEvent());
              //pasar los datos de currentRoute a OnToggleDegreeView(true)
            }, 
            icon: const Icon(
              Icons.remove_red_eye_sharp,
              size: 22
              ),
            label: const Text('Centrar vista'),
            style: const ButtonStyle(
              minimumSize: WidgetStatePropertyAll(Size(155, 45))
            ),
          );
      },
    );
  }
}
