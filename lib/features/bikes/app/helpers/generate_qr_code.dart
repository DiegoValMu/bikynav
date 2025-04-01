
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
Future<void> generateQRCode(BuildContext context, dynamic data, String type) async {
  try {
    String qrValidationData = '';
    if (type == 'bike' && data is String) {
      qrValidationData = 'bike:${jsonEncode(data)}';
    } else if (type == 'route' && data is String) {
      qrValidationData = 'route:${ jsonEncode(data) }';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tipo de datos no válido para generar QR")));
      return;
    }

    final qrWidget = QrImageView(
      data: qrValidationData,
      size: 300.0,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ZoomIn(
          child: AlertDialog(
            title: Text('Codigo QR (${type == 'bike' ? 'Bicicleta' : 'Ruta'})', textAlign: TextAlign.center,),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              FilledButton.icon(
                onPressed: (){

                },
                label: const Text('Compartir'),
                icon: const Icon( Icons.share ),
              ),
              FilledButton.icon(
                onPressed: (){

                },
                label: const Text('Guardar'),
                icon: const Icon( Icons.save ),
              )
            ],
            contentPadding: const EdgeInsets.all(15),
            content: 	SizedBox(
              width: 300,
              height: 300,
              child: Center(
                child: qrWidget
              )
            ),
          ),
        );
      },
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al generar el QR")));
  }
}