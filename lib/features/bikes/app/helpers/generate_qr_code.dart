
import 'package:bikynav/features/bikes/config/models/bike_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future<void> generateQRCode(BuildContext context, Bikes bike) async {
    try {      
      // Generar el QR en el widget
      final qrValidationData = bike.toJson().toString(); // Los datos que deseas incluir en el QR

      // Crear el widget QRImageView
      final qrWidget = QrImageView(
        data: qrValidationData,
        size: 300.0,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Codigo QR', textAlign: TextAlign.center,),
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
            content:  SizedBox(
                width: 300,
                height: 300,
                child: Center(
                  child: qrWidget
                )
              ),
          );
        },
      );
    } catch (e) {
      print("Error al generar y guardar el QR: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al generar el QR")));
    }
  }