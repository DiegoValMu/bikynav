import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';

class BtnFollowUser extends StatelessWidget {
  const BtnFollowUser({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 25,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return IconButton(
                icon: Icon(state.isfollowingUser
                    ? Icons.directions_bike_rounded
                    : Icons.hail_rounded),
                onPressed: () {
                  state.isfollowingUser
                  ? mapBloc.add(OnStopFollowingUserEvent())
                  : mapBloc.add(OnStartFollowingUserEvent());
                });
          },
        ),
      ),
    );
  }
}
