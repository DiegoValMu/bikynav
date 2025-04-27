import 'package:animate_do/animate_do.dart';
import 'package:bikynav/features/nav/app/services/marker_service.dart';
import 'package:bikynav/features/route/app/helpers/real_time_provider.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:provider/provider.dart';

class BtnCancelRoute extends StatelessWidget {

  final bool steps;
  final VoidCallback onCancel;

  BtnCancelRoute({
    super.key, 
    required this.steps, 
    required this.onCancel
  });

  @override
  Widget build(BuildContext context) {
    final stopwatchProvider = Provider.of<StopwatchProvider>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final routeServices = Provider.of<RouteServices>(context, listen: false);
    final markerServices = Provider.of<MarkerServices>(context, listen: false); 
    final markerId = markerServices.setMarker!.markerId.value;

    return ZoomIn(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: CircleAvatar(
          maxRadius: 30,
          backgroundColor: Color.fromARGB(200, 255, 255, 255),
          child: BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon( Icons.clear, color: Colors.black,),
                onPressed: () {
                  mapBloc.add(const OnToggleDegreeView(false, 0, 15));
                  mapBloc.add( OnCancelRoute() );
                  mapBloc.add(OnStopFollowingUserEvent());
                  routeServices.infoPlace = null;
                  if ( state.showMyRoute ){
                    //locationBloc.state.myLocationHistory = [];
                    stopwatchProvider.resetTimer();
                    state.polylines.remove('myRoute');
                    mapBloc.add( OnCancelToggleUserRoute() );
                  }
                  
                  if (state.markers.isNotEmpty){
                    state.markers.remove(markerId);
                    state.polylines.remove('route');
                    state.markers.remove('start');
                    state.markers.remove('end');
                    state.polylines.remove('navigationRoute');
                    state.markers.remove('navigationStart');
                    state.markers.remove('navigationEnd');
                  }
                  onCancel();
                }
              );
            },
          ),
        ),
      ),
    );
  }
}