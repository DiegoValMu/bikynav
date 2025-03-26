import 'package:bikynav/shared/views/nav_items.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarItemData {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  BottomNavigationBarItemData({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });
}

class BuildBottomNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItemData> items;

  const BuildBottomNavigationBar({super.key, required this.items});

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
          children: buildNavItems(context, items),
        ),
      ),
    );
  }

  

  
}