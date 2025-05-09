import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

Future<void> generateQRCode(BuildContext context, dynamic data, String type) async {
  try {
    String qrValidationData = '';
    if (type == 'bike' && data is String) {
      qrValidationData = 'bike:${jsonEncode(data)}';
    } else if (type == 'route' && data is String) {
      qrValidationData = 'route:${jsonEncode(data)}';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tipo de datos no válido para generar QR")));
      return;
    }

    final qrKey = GlobalKey();

    final qrWidget = QrImageView(
      data: qrValidationData,
      size: 300.0,
    );
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ZoomIn(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              title: Text('Codigo QR (${type == 'bike' ? 'Bicicleta' : 'Ruta'})', textAlign: TextAlign.center),
              actionsAlignment: MainAxisAlignment.center,
              backgroundColor: Colors.white,
              actions: [
                FilledButton.icon(
                  onPressed: () async {
                    final imagePath = await generateImageQr(qrKey);
                    await Share.shareXFiles([XFile(imagePath)], text: 'Aquí está el QR generado!');
                  },
                  label: const Text('Compartir'),
                  icon: const Icon(Icons.share),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    final image = await generateImageQr(qrKey);
                    await FlutterImageGallerySaver.saveFile( image);
            
                    await checkSaveQr(context);
                    context.pop();
                  },
                  label: const Text('Guardar'),
                  icon: const Icon(Icons.save),
                ),
              ],
              contentPadding: const EdgeInsets.all(15),
              content: SizedBox(
                width: 300,
                height: 300,
                child: Center(
                  child: RepaintBoundary(
                    key: qrKey,
                    child: qrWidget
                  )
                ),
              ),
            ),
          ),
        );
      },
    );
   
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al generar el QR")));
  }
}

Future<dynamic> checkSaveQr(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return ZoomIn(
        child: const AlertDialog(
          content: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 40),
                SizedBox(width: 10),
                Text("QR guardado correctamente"),
              ],
            ),
          ),
        ),
      );
    },
  );
}

generateImageQr(GlobalKey qrKey) async {
  final boundary = qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
  var image = await boundary.toImage();
  ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
  Uint8List pngBytes = byteData!.buffer.asUint8List();
  // Obtener el directorio para guardar la imagen
  final directory = await getExternalStorageDirectory();
  final imagePath = '${directory!.path}/qr_code.png';
  // Guardar la imagen
  File(imagePath).writeAsBytesSync(pngBytes);

  return imagePath;
}

Future<void> requestPermission(BuildContext context) async {
  if (await Permission.storage.request().isGranted) {
    // El permiso fue concedido, puedes guardar la imagen
  } else {
    // El permiso fue denegado
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permiso denegado para acceder a la galería')));
  }
}
