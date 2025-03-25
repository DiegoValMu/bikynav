
import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BuildBottomNavigationBar extends StatelessWidget {
  const BuildBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomAppBar(
        shadowColor: Colors.black,
        height: 65,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              context,
              Icons.search,
              'Buscar',
              () => context.push('/search_bike'),
            ),
            const VerticalDivider(width: 20, thickness: 1),
            _buildNavItem(
              context,
              Icons.qr_code_scanner,
              'Escanear QR',
              (){
                context.push('/scanner_qr');
              },
            ),
            const VerticalDivider(width: 20, thickness: 1),
            _buildNavItem(
              context,
              Icons.add_circle,
              'Agregar',
              () async { 
                showLoadingMessage(context);
                await Future.delayed(Duration(milliseconds: 500)); 
                await context.push('/add_bike');
                hideLoadingMessage(context);
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildNavItem(BuildContext context, IconData icon, String label, VoidCallback onPressed, {Color? color}) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          Text(label),
        ],
      ),
    );
  }

}