// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:bikynav/features/bikes/presentation/screens/update_bike_data.dart';
import 'package:bikynav/features/route/presentation/widgets/btn_toggle_user_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/app/delegates/delegates.dart';
import 'package:bikynav/features/nav/config/models/models.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  double _height = 110; // Altura inicial del contenedor
  final double _minHeight = 110; // Altura mínima
  final double _maxHeight = 400; // Altura máxima

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
            ? const SizedBox()
            : FadeInDown(
                duration: const Duration(milliseconds: 300),
                child: _CustomSearchBarBody(
                  height: _height,
                  minHeight: _minHeight,
                  maxHeight: _maxHeight,
                  onHeightChanged: (double newHeight) {
                    setState(() {
                      _height = newHeight.clamp(_minHeight, _maxHeight);
                    });
                  },
                ),
              );
      },
    );
  }
}

class _CustomSearchBarBody extends StatelessWidget {
  const _CustomSearchBarBody({
    required this.height,
    required this.minHeight,
    required this.maxHeight,
    required this.onHeightChanged,
  });

  final double height; // Altura del contenedor
  final double minHeight; // Altura mínima
  final double maxHeight; // Altura máxima
  final ValueChanged<double> onHeightChanged; // Callback para actualizar la altura

  // Función llamada al presionar el buscador
  void onSearchResult(BuildContext context, SearchResult result) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);

    // Si es manual
    if (result.manual == true) {
      searchBloc.add(OnActivateManualMarkerEvent());
      onHeightChanged(minHeight);
      return;
    }
    // Cualquier otro caso
    if (result.position != null) {

      
      final start = locationBloc.state.lastKnowlocation;
      if (start == null) return;
      final position = result.position;
      final end = LatLng(position!.longitude, position.latitude);
      final destination = await searchBloc.getCoorsStartToEnd(start, end);

      onHeightChanged(minHeight);

      await mapBloc.drawRoutePolyline(destination);
      mapBloc.add( OnInitRoute() );
      
    }
  }

  @override
  Widget build(BuildContext context) {

    //final mapBloc = BlocProvider.of<MapBloc>(context);
    //final locationBloc = BlocProvider.of<LocationBloc>(context);

    //final userLocation = locationBloc.state.myLocationHistory;

    final width = MediaQuery.of(context).size.width;

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
          decoration: BoxDecoration(
            color: Colors.white, // Color de fondo de la barra de búsqueda
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), // Esquinas redondeadas (opcional)
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Color de la sombra
                spreadRadius: 2, // Expansión de la sombra
                blurRadius: 8, // Desenfoque de la sombra
                offset: const Offset(0, -2), // Sombra hacia arriba
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20), // Padding horizontal
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Barra decorativa (similar a Waze)
                Container(
                  height: 5, // Altura de la barra decorativa
                  width: 40, // Anchura de la barra
                  margin: const EdgeInsets.only(top: 8, bottom: 10), // Margen para separación
                  decoration: BoxDecoration(
                    color: Colors.grey[400], // Color de la barra decorativa
                    borderRadius: BorderRadius.circular(10), // Esquinas redondeadas
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await showSearch(
                        context: context, delegate: SearchDestinationDelegate());
                    if (result == null) return;
            
                    onSearchResult(context, result);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                    margin: const EdgeInsets.only( bottom: 25),
                    width: width, // Asegura que el ancho sea completo
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.black87), // Icono de búsqueda
                        SizedBox(width: 10),
                        Text('¿Dónde quieres ir?',
                            style: TextStyle(color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Divider(),
                        SizedBox(
                          height: 70,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const BtnToggleUserRoute(),
                              const VerticalDivider(width: 20, thickness: 1),
                              InkWell(
                                onTap: () {
                                  context.push('/scanner_qr');
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric( vertical: 10, horizontal: 20 ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon( Icons.qr_code_scanner ),
                                      Text('Escanear QR'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        
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
