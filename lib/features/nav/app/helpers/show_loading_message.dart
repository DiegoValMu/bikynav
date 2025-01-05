import 'package:flutter/material.dart';

void showLoadingMessage( BuildContext context) {

  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: ( context ) => AlertDialog( 
      title: const Center(child: Text('Espere por favor')),
      content: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only( top: 10 ),
        child: const Column(
          children: [
            Text('Procesando solicitud'),
            SizedBox( height: 15 ),
            CircularProgressIndicator( strokeWidth: 3, color: Colors.black)
          ],
        )),
    ));

   

    return;

}

 void hideLoadingMessage(BuildContext context) {
      Navigator.pop(context);  // Cierra el diálogo de carga
    }