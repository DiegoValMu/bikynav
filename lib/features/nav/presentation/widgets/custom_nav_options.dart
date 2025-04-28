import 'package:bikynav/features/nav/app/blocs/location/location_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/map/map_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/search/search_bloc.dart';
import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/nav/app/services/marker_service.dart';
import 'package:bikynav/features/nav/config/models/markers_model.dart';
import 'package:bikynav/features/route/presentation/widgets/btn_toggle_user_route.dart';
import 'package:bikynav/shared/views/nav_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class NavOptions extends StatelessWidget {
  const NavOptions({
    super.key,
  });

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
              showLoadingMessage(context);
              final mapBloc = BlocProvider.of<MapBloc>(context, listen: false);
              final markerServices = Provider.of<MarkerServices>(context, listen: false); 
              final locationBloc = BlocProvider.of<LocationBloc>(context);
              final actualLocation = locationBloc.state.lastKnowlocation;
              final searchBloc = BlocProvider.of<SearchBloc>(context);
              markerServices.dataActualPlace = await searchBloc.getInformationPlace(actualLocation!);

              final ciudadActual = markerServices.dataActualPlace!.properties.placeFormatted.split(',').first;

              await markerServices.getTallerMarkers(ciudadActual);
              hideLoadingMessage(context);

              

              markerServices.markersSelected = 'taller';


              mapBloc.add(OnSelectTallerMarker());
              await Future.delayed(const Duration(milliseconds: 300));


              //vista de todos los talleres de la ciudad 

              final talleres = markerServices.infoMarkers;
              List<LatLng>? markerPoints = [];

              talleres.map((Markers marcador) {
                markerPoints.add(LatLng(marcador.pos![0], marcador.pos![1]));
              }).toList();

              mapBloc.add(FocusOnRouteEvent(markerPoints));

              //--------------------------------------------------------------
              
              
            }
          ),
          const VerticalDivider(width: 20, thickness: 1),
          buildNavItem(
            context, 
            Icons.directions_bike_outlined, 
            'Mostrar Rutas', 
            () {
              //final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
              //searchBloc.add(OnActivateManualPinMarkerEvent());
            }
          ),
          const VerticalDivider(width: 20, thickness: 1),
          buildNavItem(
            context, 
            Icons.emoji_events_outlined, 
            'Ver Eventos', 
            () {
              //final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
              //searchBloc.add(OnActivateManualPinMarkerEvent());
            }
          ),
        ],
      ),
    );
  }
}