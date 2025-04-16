import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomChangeMapView extends StatelessWidget {
  final VoidCallback onPressed; // Nueva propiedad
  final MapType currentMapType; 

  const CustomChangeMapView({
    super.key, 
    required this.onPressed, 
    required this.currentMapType, // Requerida en el constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
        maxRadius: 25,
        child: IconButton(
          icon: Icon(
            currentMapType == MapType.normal 
              ? Icons.map    // Icono para modo normal
              : Icons.satellite,
            color: currentMapType == MapType.normal 
              ? Colors.indigo 
              : Colors.green[800],
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}