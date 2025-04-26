import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:bikynav/features/bikes/app/helpers/generate_qr_code.dart';
import 'package:bikynav/features/bikes/config/models/bike_model.dart';
import 'package:bikynav/features/bikes/presentation/screens/update_bike_data.dart';
import 'package:flutter/material.dart';

void showBikeDetails(BuildContext context, Bikes bike) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: ZoomIn(
          child: AlertDialog(
            shadowColor: Colors.black,
            backgroundColor: Colors.white,
            title: null,
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              FilledButton.icon(
                onPressed: () {
                  generateQRCode(context, bike.id, 'bike');
                },
                label: const Text('Generar QR'),
                icon: const Icon( Icons.qr_code ),
              ),
            ],
            content: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/noimage.jpg',
                        width: 250,
                        height: 300,
                      ),
                      _buildInfoRow('Marca', '${bike.marca}'),
                      _buildInfoRow('Modelo', '${bike.modelo}'),
                      _buildInfoRow('Aro', '${bike.aro}'),
                      _buildInfoRow('Tipo', '${bike.tipo}'),
                      _buildInfoRow('Talla', '${bike.talla}'),
                      _buildInfoRow('color', '${bike.colorPrincipal}'),
                      _buildInfoRow('Modelo del cuadro', '${bike.modeloCuadro}'),
                      _buildInfoRow('Codigo de serie', '${bike.codigoSerie}'),
                    ],
                  ),
                ),
                
                Positioned(
                  right: 0,
                  top: 0,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateBikeDataScreen(bike: bike), // Pasa el objeto Bikes aquí
                        ),
                      );
                    },
                    child: const Icon( Icons.edit, size: 20, ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildInfoRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5 ),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(value),
        ),
      ],
    ),
  );
}