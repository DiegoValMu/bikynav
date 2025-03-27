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
    return SizedBox(
      height: 70,
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
            Icons.push_pin, 
            'Colocar pin', 
            () {
              context.push('/scanner_qr');
            }
          ),
        ],
      ),
    );
  }
}