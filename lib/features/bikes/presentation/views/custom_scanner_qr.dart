import 'dart:convert';
import 'package:bikynav/features/bikes/app/helpers/blinking_cornes.dart';
import 'package:bikynav/features/bikes/config/models/bike_model.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerQr extends StatefulWidget {
  const ScannerQr({super.key});

  @override
  State<ScannerQr> createState() => _ScannerQrState();
}

class _ScannerQrState extends State<ScannerQr> {
  Barcode? _barcode;
  bool _isTorchOn = false;
  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[800]
        ),
        child: IconButton(
          icon: Icon( 
            _isTorchOn 
            ? Icons.flashlight_on
            : Icons.flashlight_off, color: Colors.white),
          onPressed: () {
            setState(() {
              _isTorchOn = !_isTorchOn;
            });
            cameraController.toggleTorch();
          },
        ),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(
              onDetect: _handleBarcode,
              controller: cameraController,
            ),
          ),
          BlinkingCorners(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}