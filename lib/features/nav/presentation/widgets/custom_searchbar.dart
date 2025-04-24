
import 'package:animate_do/animate_do.dart';
import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/nav/presentation/widgets/widgets.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/app/delegates/delegates.dart';
import 'package:bikynav/features/nav/config/models/models.dart';
import 'package:provider/provider.dart';

class CustomSearchBar extends StatefulWidget {
  final VoidCallback onMenuPressed;
  
  const CustomSearchBar({
    super.key, 
    required this.onMenuPressed
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
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
          child: _CustomSearchBarBody(
            height: _height,
            minHeight: _minHeight,
            maxHeight: _maxHeight,
            routeServices: routeServices,
            onMenuPressed: widget.onMenuPressed,
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

class _CustomSearchBarBody extends StatelessWidget {
  const _CustomSearchBarBody({
    required this.height,
    required this.minHeight,
    required this.maxHeight,
    required this.onHeightChanged, 
    this.routeServices, 
    required this.onMenuPressed,
  });


  final VoidCallback onMenuPressed;
  final routeServices;
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

      showLoadingMessage(context);

      final start = locationBloc.state.lastKnowlocation;
      if (start == null) return;

      final position = result.position;
      final end = LatLng(position!.longitude, position.latitude);
      final destination = await searchBloc.getCoorsStartToEnd(start, end);

      onHeightChanged(minHeight);
      await mapBloc.drawRoutePolyline(destination);
      routeServices.selectNavRoute = result.id;
      mapBloc.add( OnInitRoute() );

      hideLoadingMessage(context);
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final history = BlocProvider.of<SearchBloc>(context).state.history;
    final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
    final locationBloc = BlocProvider.of<LocationBloc>(context, listen: false);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return SafeArea(
  bottom: true,
  child: GestureDetector(
    onVerticalDragUpdate: (details) {
      onHeightChanged(height - details.delta.dy);
    },
    onVerticalDragEnd: (details) {
      if (details.primaryVelocity! < 0) {
        onHeightChanged(maxHeight);
      } else {
        onHeightChanged(minHeight);
      }
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Parte superior FIJADA (no desplazable)
          Column(
            children: [
              const DecorativeBar(),
              Row(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await showSearch(
                          context: context, delegate: SearchDestinationDelegate());
                      if (result == null) return;
                      onSearchResult(context, result);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                      margin: const EdgeInsets.only(bottom: 25),
                      width: width - 75,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.black87),
                          SizedBox(width: 10),
                          Text('¿Dónde quieres ir?',
                              style: TextStyle(color: Colors.black87)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: IconButton(
                      onPressed: onMenuPressed,
                      icon: const Icon(Icons.menu, color: Colors.black),
                      iconSize: 28,
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.grey[200]),
                        padding: WidgetStatePropertyAll(EdgeInsets.all(10)),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              NavOptions(),
              const Divider(),
            ],
          ),
          
          // Parte inferior DESPLAZABLE
          if (history.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Recientes'),
                    ),
                    ...history.map((place) => Column(
                      children: [
                        ListTile(
                          title: Text(place.properties.name, 
                            style: const TextStyle(fontSize: 15)),
                          subtitle: Text(place.properties.placeFormatted),
                          leading: const Icon(Icons.place_outlined, color: Colors.black),
                          onTap: () async {

                            final result = SearchResult(
                              id: place.id, // cambiar para que sea dinamico
                              cancel: false, 
                              manual: false,
                              position: LatLng( place.properties.coordinates.longitude, place.properties.coordinates.latitude),
                              name: place.properties.name,
                              description: place.properties.placeFormatted
                            );
                            onSearchResult(context, result);

                          },
                        ),
                        const Divider(),
                      ],
                    )),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  ),
);
  }
}




