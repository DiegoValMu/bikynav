import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';

class BtnFollowUser extends StatelessWidget {

  const BtnFollowUser({super.key});

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
              mapBloc.add(const OnToggleDegreeView(false, 0, 15));
              mapBloc.add(FocusOnRouteEvent(currentRoute!.points));
            },
            label: const Text('Vista completa'),
            style: const ButtonStyle(
              minimumSize: WidgetStatePropertyAll(Size(155, 45)),
              backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(255, 255, 255, 0.8),)
            )
          )
        : FilledButton.icon(
            onPressed: (){
              final initialBearing = currentRoute?.initialBearing;
              mapBloc.add(OnStartFollowingUserEvent());
              mapBloc.add(OnToggleDegreeView(
                true, 
                initialBearing!.toDouble(),
                19
              ));
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
