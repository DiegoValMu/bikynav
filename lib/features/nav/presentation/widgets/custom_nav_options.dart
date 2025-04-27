import 'package:bikynav/features/route/presentation/widgets/btn_toggle_user_route.dart';
import 'package:bikynav/shared/views/nav_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            () {
              //final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
              //searchBloc.add(OnActivateManualPinMarkerEvent());
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