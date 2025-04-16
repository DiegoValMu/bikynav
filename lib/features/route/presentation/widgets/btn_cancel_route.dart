import 'package:bikynav/features/route/app/helpers/real_time_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:provider/provider.dart';

class BtnCancelRoute extends StatelessWidget {
  const BtnCancelRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final stopwatchProvider = Provider.of<StopwatchProvider>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return IconButton(
              icon: const Icon( Icons.clear, color: Colors.black,),
              onPressed: () {
                mapBloc.add( OnCancelRoute() );
                if ( state.showMyRoute ){
                  //locationBloc.state.myLocationHistory = [];
                  stopwatchProvider.resetTimer();
                  mapBloc.add( OnCancelToggleUserRoute() );
                }
                
                if (state.markers.isNotEmpty){
                  state.polylines.remove('route');
                  state.markers.remove('start');
                  state.markers.remove('end');
                }
              }
            );
          },
        ),
      ),
    );
  }
}