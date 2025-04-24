
import 'package:animate_do/animate_do.dart';
import 'package:bikynav/features/nav/presentation/widgets/widgets.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:provider/provider.dart';

class CustomMarkerForm extends StatefulWidget {
  final VoidCallback onCloseTap;
  
  const CustomMarkerForm({
    super.key, 
    required this.onCloseTap, 
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomMarkerFormState createState() => _CustomMarkerFormState();
}

class _CustomMarkerFormState extends State<CustomMarkerForm> {
  double _height = 120; // Altura inicial del contenedor
  final double _minHeight = 120; // Altura mínima
  final double _maxHeight = 400; // Altura máxima
  

  @override
  Widget build(BuildContext context) {
    final routeServices = Provider.of<RouteServices>(context);
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return (state.displayManualMarker || state.displayManualPinMarker )
        ? const SizedBox( )
        : FadeInDown(
          duration: const Duration(milliseconds: 300),
          child: _CustomMarkerFormBody(
            height: _height,
            minHeight: _minHeight,
            maxHeight: _maxHeight,
            routeServices: routeServices,
            onCloseTap: widget.onCloseTap,
            onHeightChanged: (double newHeight) {
              setState( () {
                _height = newHeight.clamp(_minHeight, _maxHeight);
                }
              );
            },
          ),
        );
      },
    );
  }
}

class _CustomMarkerFormBody extends StatelessWidget {
  const _CustomMarkerFormBody({
    required this.height,
    required this.minHeight,
    required this.maxHeight,
    required this.onHeightChanged, 
    this.routeServices, 
    required this.onCloseTap, 
  });

  final VoidCallback onCloseTap;
  final routeServices;
  final double height; // Altura del contenedor
  final double minHeight; // Altura mínima
  final double maxHeight; // Altura máxima
  final ValueChanged<double> onHeightChanged; // Callback para actualizar la altura

  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context, listen: false);
    

    return SafeArea(
      bottom: true,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          // Cambia la altura según el movimiento del drag
          onHeightChanged(height - details.delta.dy);
        },
        onVerticalDragEnd: (details) {
          // Establece la altura final en función de la dirección del movimiento
          if (details.primaryVelocity! < 0) {
            // Si se deslizaba hacia arriba
            onHeightChanged(maxHeight); // Expande completamente
          } else {
            // Si se deslizaba hacia abajo
            onHeightChanged(minHeight); // Vuelve a la altura mínima
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200), // Duración de la animación
          height: height, // Ajusta la altura según el valor pasado
          decoration: const BoxDecoration(
            color: Colors.white, // Color de fondo de la barra de búsqueda
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Esquinas redondeadas (opcional)
            boxShadow: [
              BoxShadow(
                color: Colors.black, // Color de la sombra
                blurRadius: 2, // Desenfoque de la sombra
                offset: Offset(0, 0), // Sombra hacia arriba
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10), // Padding horizontal
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const DecorativeBar(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        mapBloc.state.markers.remove('newMarker');

                        onCloseTap();
                      }, 
                      icon: Icon( Icons.close )
                    )
                  ],
                ),
                const Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Divider(),

                        Divider(),
                      ],
                    ),
                  ),
                ),
                //widgets al expandir
              ],
            ),
          ),
        ),
      ),
    );
  }
}




