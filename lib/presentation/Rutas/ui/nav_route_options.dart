
import 'package:bikynav/app/helpers/show_loading_message.dart';
import 'package:bikynav/app/services/route_service.dart';
import 'package:flutter/material.dart';

import '../../../app/blocs/blocs.dart';

class NavRouteOptions extends StatelessWidget {
  const NavRouteOptions({
    super.key,
    required this.locationBloc,
    required this.routeServices,
    required this.searchBloc,
    required this.mapBloc,
  });

  final LocationBloc locationBloc;
  final RouteServices routeServices;
  final SearchBloc searchBloc;
  final MapBloc mapBloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         
        IconButton(
          onPressed: () async {
            showLoadingMessage(context);
            final currentLocation = locationBloc.state.lastKnowlocation!;
            final routeStart = routeServices.myRoute.ubicacionInicial!;
            
            
            final navigationPath = await searchBloc.getCoorsStartToEnd(
              currentLocation, 
              routeStart
            );
            
            await mapBloc.drawRoutePolyline(navigationPath);

            


            mapBloc.add(OnInitRoute());
            
            hideLoadingMessage(context);
          }, 
      
          icon: const Icon(Icons.directions_bike_outlined),
          style: const ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size(155, 45)),
          ),
        ),
      ],
    );
  }
}
