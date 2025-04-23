import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

String selectMarkerForm(BuildContext context) {

  String onSelect = '';

  showDialog(
    context: context,
    builder: (context) => ZoomIn(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20.0), // Ajusta este valor
          backgroundColor: Colors.white,
          title: Text('Tipo de marcador', textAlign: TextAlign.center,),
          content: Container(
            // El width aquí ya no es tan crítico si usas insetPadding
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(),
                FilledButton.icon(
                  onPressed: () => onSelect = 'taller', 
                  label: Text('Taller'),
                  icon: Icon(Icons.build_rounded),
                  style: const ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(155, 45)),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => onSelect = 'evento', 
                  label: Text('Evento'),
                  icon: Icon(Icons.event),
                  style: const ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(155, 45)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  return onSelect;
}