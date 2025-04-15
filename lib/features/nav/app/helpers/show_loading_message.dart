import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

void showLoadingMessage(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ZoomIn(
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 120.0), // Ajusta este valor
        backgroundColor: Colors.white,
        content: Container(
          // El width aquí ya no es tan crítico si usas insetPadding
          height: 60,
          margin: const EdgeInsets.only(top: 10),
          child: const Column(
            children: [
              SizedBox(height: 15),
              CircularProgressIndicator(strokeWidth: 3, color: Colors.black),
            ],
          ),
        ),
      ),
    ),
  );

  return;
}

void hideLoadingMessage(BuildContext context) {
  Navigator.pop(context); // Cierra el diálogo de carga
}