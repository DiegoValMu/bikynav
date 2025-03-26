import 'package:bikynav/shared/ui/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

List<Widget> buildNavItems(BuildContext context, List<BottomNavigationBarItemData> items) {
    final List<Widget> navItems = [];
    for (int i = 0; i < items.length; i++) {
      navItems.add(
        buildNavItem(
          context,
          items[i].icon,
          items[i].label,
          items[i].onPressed,
          color: items[i].color,
        ),
      );
      if (i < items.length - 1) {
        navItems.add(const VerticalDivider(width: 20, thickness: 1));
      }
    }
    return navItems;
  }

  Widget buildNavItem(BuildContext context, IconData icon, String label, VoidCallback onPressed, {Color? color}) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            Text(label),
          ],
        ),
      ),
    );
  }