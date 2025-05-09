import 'package:bikynav/app/blocs/location/location_bloc.dart';
import 'package:bikynav/app/blocs/map/map_bloc.dart';
import 'package:bikynav/app/blocs/search/search_bloc.dart';
import 'package:bikynav/app/helpers/show_loading_message.dart';
import 'package:bikynav/app/services/marker_service.dart';
import 'package:bikynav/config/models/markers_model.dart';
import 'package:bikynav/app/services/route_service.dart';
import 'package:bikynav/config/models/routes.dart';
import 'package:bikynav/presentation/Rutas/widgets/btn_toggle_user_route.dart';
import 'package:bikynav/presentation/shared/views/nav_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class NavOptions extends StatelessWidget {
  const NavOptions({
    super.key,
  });

  Future<void> _handleMarkersAction(
    BuildContext context, {
    required String markerType,
    required Function markerEvent,
  }) async {
    showLoadingMessage(context);
    
    final mapBloc = BlocProvider.of<MapBloc>(context, listen: false);
    final markerServices = Provider.of<MarkerServices>(context, listen: false);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final actualLocation = locationBloc.state.lastKnowlocation;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    
    markerServices.dataActualPlace = await searchBloc.getInformationPlace(actualLocation!);
    final ciudadActual = markerServices.dataActualPlace!.properties.placeFormatted.split(',').first;

    if(markerType == 'taller'){
      await markerServices.getTallerMarkers(ciudadActual);
    }

    if(markerType == 'evento'){
      await markerServices.getEventMarkers(ciudadActual);
    }
    
    hideLoadingMessage(context);
    markerServices.markersSelected = markerType;
    
    markerEvent();
    await Future.delayed(const Duration(milliseconds: 300));

    final markers = markerServices.infoMarkers;
    final markerPoints = markers.map((marcador) => 
      LatLng(marcador.pos![0], marcador.pos![1])).toList();

    mapBloc.add(FocusOnRouteEvent(markerPoints));
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const BtnToggleUserRoute(),
          const VerticalDivider(width: 20, thickness: 1),
          buildNavItem(
            context, 
            Icons.qr_code_scanner, 
            'Escanear QR', 
            () {
              context.push('/scanner_qr');
            }
          ),
          const VerticalDivider(width: 20, thickness: 1),
          buildNavItem(
            context, 
            Icons.report_outlined, 
            'Alertar robo', 
            () {
              //final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
              //searchBloc.add(OnActivateManualPinMarkerEvent());
            }
          ),
          const VerticalDivider(width: 20, thickness: 1),
          buildNavItem(
            context, 
            Icons.home_repair_service, 
            'Ver Talleres', 
            () async {
              await _handleMarkersAction(
                context,
                markerType: 'taller',
                markerEvent: () => BlocProvider.of<MapBloc>(context).add(OnSelectTallerMarker()),
              );
            }
          ),
          const VerticalDivider(width: 20, thickness: 1),
          buildNavItem(
            context, 
            Icons.directions_bike_outlined, 
            'Mostrar Rutas', 
            () async {
              showLoadingMessage(context);
              final mapBloc = BlocProvider.of<MapBloc>(context, listen: false);
              final markerServices = Provider.of<MarkerServices>(context, listen: false);
              final routeServices = Provider.of<RouteServices>(context, listen: false);
              final locationBloc = BlocProvider.of<LocationBloc>(context);
              final actualLocation = locationBloc.state.lastKnowlocation;
              final searchBloc = BlocProvider.of<SearchBloc>(context);

              routeServices.infoPlace = await searchBloc.getInformationPlace(actualLocation!);
              final ciudadActual = routeServices.infoPlace!.properties.placeFormatted.split(',').first;

              await routeServices.getRoutesByCity(ciudadActual);
              BlocProvider.of<MapBloc>(context).add(OnSelectRoutes());

              hideLoadingMessage(context);
              markerServices.markersSelected = 'routes';

              await Future.delayed(const Duration(milliseconds: 300));

              final routes = routeServices.rutas2;

              final markerPoints = routes.map((marcador) => 
                LatLng(marcador["ubicacion_inicial"][0], marcador["ubicacion_inicial"][1])).toList();

              mapBloc.add(FocusOnRouteEvent(markerPoints));
            }
          ),
          const VerticalDivider(width: 20, thickness: 1),
          buildNavItem(
            context, 
            Icons.emoji_events_outlined, 
            'Ver Eventos', 
            () async {
              await _handleMarkersAction(
                context,
                markerType: 'evento',
                markerEvent: () => BlocProvider.of<MapBloc>(context).add(OnSelectEventMarker()),
              );
            }
          ),
        ],
      ),
    );
  }
}