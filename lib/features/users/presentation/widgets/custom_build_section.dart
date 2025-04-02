import 'package:flutter/material.dart';

Widget buildSection({required String title, required List<Widget> children}) {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.2),
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ExpansionTile(
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: const Icon(Icons.info),
        ),
        dense: true,
        showTrailingIcon: false,
        title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        initiallyExpanded: true,
        maintainState: true,
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
        collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
        children: children,
      ),
    ),
  );
}