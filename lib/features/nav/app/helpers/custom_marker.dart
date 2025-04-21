import 'dart:ffi';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getAssetImageMarker (String marker, double width, double height){

  return BitmapDescriptor.asset(
    ImageConfiguration(
      devicePixelRatio: 2.5,
      size: ui.Size(width, height),
    ), 
    'assets/markers/$marker',
    
    );

}


Future<BitmapDescriptor> getNetworkImageMarker (String marker) async {

  final res = await Dio().get(
    'marker',
    options: Options( responseType: ResponseType.bytes )
  );

  final imageCodec = await ui.instantiateImageCodec(res.data, targetHeight: 100, targetWidth: 100);
  final frame = await imageCodec.getNextFrame();
  final data = await frame.image.toByteData( format: ui.ImageByteFormat.png);

  if ( data == null ){
    return await getAssetImageMarker(marker, 50, 50);
  }


  return BitmapDescriptor.bytes( data.buffer.asUint8List());

}


