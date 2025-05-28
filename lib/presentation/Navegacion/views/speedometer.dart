import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikynav/app/blocs/blocs.dart';

class CustomSpeedDometer extends StatelessWidget {
  const CustomSpeedDometer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        // Obtener velocidad y convertir de m/s a km/h
        final speedKmh = state.speed != null ? state.speed! * 3.6 : null;
        final speedText = speedKmh != null ? '${speedKmh.toStringAsFixed(0)}' : '--';
        
        // Color basado en la velocidad
        Color speedColor = Colors.black87;
        Color textColor = Colors.white;
        if (speedKmh != null) {
          if (speedKmh > 5) speedColor = Colors.green;
          if (speedKmh > 20) speedColor = Colors.orange;
          if (speedKmh > 40) speedColor = Colors.red;
        }

        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ZoomIn(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: speedColor,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
                maxRadius: 25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      speedText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        
                      ),
                    ),
                    Text(
                      'km/h',
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor,
                        height: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}