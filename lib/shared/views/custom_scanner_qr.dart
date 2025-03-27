import 'dart:convert';

import 'package:bikynav/features/bikes/app/helpers/blinking_cornes.dart';
import 'package:bikynav/features/bikes/config/models/bike_model.dart';
import 'package:bikynav/features/bikes/presentation/views/show_bike_details.dart';
import 'package:bikynav/features/nav/app/blocs/map/map_bloc.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/features/route/config/models/routesById.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class ScannerQr extends StatefulWidget {
  const ScannerQr({super.key});

  @override
  State<ScannerQr> createState() => _ScannerQrState();
}

class _ScannerQrState extends State<ScannerQr> {
  Barcode? _barcode;
  bool _isTorchOn = false;
  MobileScannerController cameraController = MobileScannerController();
  Bikes? bike;
  String? idRoute; // Para almacenar el id de la ruta escaneada
  bool _hasScanned = false; // Variable para controlar si ya se ha escaneado un QR

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
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[800],
      ),
      child: IconButton(
        icon: Icon(
          _isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _isTorchOn = !_isTorchOn;
          });
          cameraController.toggleTorch();
        },
      ),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (_hasScanned) return; // Si ya se ha escaneado, no hacer nada

    if (mounted) {
      final barcode = barcodes.barcodes.firstOrNull;
      if (barcode != null && barcode.rawValue != null) {
        final String rawValue = barcode.rawValue!;
        if (rawValue.startsWith('bike:')) {
          final String jsonData = rawValue.substring('bike:'.length);
          try {
            final decodedData = jsonDecode(jsonData) as Map<String, dynamic>;
            final newBike = Bikes.fromJson(decodedData);
            // Mostrar detalles de la bicicleta
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pop('/nav');
              showBikeDetails(context, newBike);
            });
            setState(() {
              _barcode = null;
              bike = newBike;
              idRoute = null;
              _hasScanned = true; // Marcar como escaneado
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al leer la información de la bicicleta')));
          }
        } else if (rawValue.startsWith('route:')) {
          final String jsonData = rawValue.substring('route:'.length);
          _hasScanned = true;
          final routeId = (jsonDecode(jsonData));
          final routeServices = Provider.of<RouteServices>(context, listen: false);
          final mapBloc = BlocProvider.of<MapBloc>(context, listen: false);
          Ruta routeById = await routeServices.getRouteById(routeId as String);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final startMarker = Marker(
              markerId: const MarkerId('start'),
              position: routeById.ubicacionInicial,
              infoWindow: const InfoWindow(title: 'Ubicación inicial'),
            );

            final endMarker = Marker(
              markerId: const MarkerId('end'),
              position: routeById.ubicacionFinal,
              infoWindow: InfoWindow(title: 'Destino', snippet: routeById.etiqueta),
            );

            final currentPolylines = Map<String, Polyline>.from(mapBloc.state.polylines);
            final points = routeById.rutaDetalles.points;
            final myRoute = Polyline(
              polylineId: const PolylineId('route'),
              color: Colors.black,
              width: 5,
              points: points,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
            );

            final currentMarkers = Map<String, Marker>.from(mapBloc.state.markers);
            currentMarkers['start'] = startMarker;
            currentMarkers['end'] = endMarker;
            currentPolylines['route'] = myRoute;

            mapBloc.add(DisplayPolylinesEvent(currentPolylines, currentMarkers));
            mapBloc.add(OnInitRoute());

            routeServices.myRoute.etiqueta = routeById.etiqueta;
            routeServices.myRoute.distancia = routeById.calcularDistancia();
            routeServices.myRoute.tiempoUtilizado = routeById.tiempo;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Seleccionaste ${routeById.etiqueta}')));
            
            
          });
          context.pop('/nav');
          _hasScanned = true;
          setState(() {
            idRoute = routeId;
            bike = null;
            _barcode = null;
            _hasScanned = true; // Marcar como escaneado
          });
        } else {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código QR no reconocido')));
            bike = null;
            idRoute = null;
            _barcode = null;
            _hasScanned = true; // Marcar como escaneado aunque no sea un QR válido
          });
        }
      } else {
        setState(() {
          bike = null;
          idRoute = null;
          _barcode = null;
        });
      }
    }
  }

  // Método para reiniciar el escáner
  void _resetScanner() {
    setState(() {
      _hasScanned = false; // Permitir escanear de nuevo
    });
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
                  // Botón para reiniciar el escáner
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
