import 'package:animate_do/animate_do.dart';
import 'package:bikynav/app/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomButtonAccuracy extends StatefulWidget {
  final VoidCallback onPressed;

  const CustomButtonAccuracy({
    super.key,
    required this.onPressed,
  });

  @override
  State<CustomButtonAccuracy> createState() => _CustomButtonAccuracyState();
}

class _CustomButtonAccuracyState extends State<CustomButtonAccuracy> {
  bool _showSlider = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            if (_showSlider)
              Positioned(
                right: 10, // Ajustado para alinear con el botón
                bottom: 70, // Colocado arriba del botón
                child: FadeInUp( // Cambiado a FadeInUp para animación hacia arriba
                  child: Container(
                    height: 200,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end, // Alinea el contenido abajo
                      children: [
                        // Icono en la parte superior (ahora que crece hacia abajo)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.tune,
                            color: Colors.indigo,
                            size: 20,
                          ),
                        ),
                        // Slider vertical (sin rotación)
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                            ),
                            child: Slider(
                              min: 1,
                              max: 20,
                              divisions: 19,
                              value: state.distanceFilter!.toDouble(),
                              onChanged: (value) {
                                context.read<LocationBloc>().add(
                                  UpdateDistanceFilter(value.toInt()),
                                );
                              },
                              onChangeEnd: (value) {
                                // Opcional: acción al soltar el slider
                              },
                              activeColor: Colors.indigo,
                              inactiveColor: Colors.indigo.withOpacity(0.3),
                            ),
                          ),
                        ),
                        // Valor actual en la parte inferior
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            '${state.distanceFilter!.toStringAsFixed(0)}m',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ZoomIn(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
                  maxRadius: 25,
                  child: IconButton(
                    icon: Icon(
                      Icons.location_searching_rounded,
                      color: Colors.indigo,
                    ),
                    onPressed: () {
                      setState(() {
                        _showSlider = !_showSlider;
                      });
                      widget.onPressed();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}