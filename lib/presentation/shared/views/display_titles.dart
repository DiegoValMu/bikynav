import 'package:flutter/material.dart';

buildTitle(double duration, double distance, String name, bool isRoute) {
    return Container(
      padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 5),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text((isRoute) ? 'Ruta': 'Dirección', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(name, style: const TextStyle(color: Colors.black87, fontSize: 14)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon((isRoute) ? Icons.route : Icons.flag, size: 18),
              Text(' $distance kms', style: const TextStyle(color: Colors.black54, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }