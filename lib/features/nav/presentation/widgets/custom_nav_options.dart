import 'package:bikynav/features/route/presentation/widgets/btn_toggle_user_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavOptions extends StatelessWidget {
  const NavOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const BtnToggleUserRoute(),
          const VerticalDivider(width: 20, thickness: 1),
          InkWell(
            onTap: () {
              context.push('/scanner_qr');
            },
            child: const Padding(
              padding: EdgeInsets.symmetric( vertical: 10, horizontal: 10 ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon( Icons.qr_code_scanner ),
                  Text('Escanear QR'),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 20, thickness: 1),
          InkWell(
            onTap: () {
              
            },
            child: const Padding(
              padding: EdgeInsets.symmetric( vertical: 10, horizontal: 10 ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon( Icons.push_pin ),
                  Text('Poner marcador'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}