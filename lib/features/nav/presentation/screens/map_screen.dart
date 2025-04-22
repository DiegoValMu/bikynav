import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:bikynav/features/nav/config/models/route_destination.dart';
import 'package:bikynav/features/nav/presentation/widgets/custom_change_map_view.dart';
import 'package:bikynav/features/route/app/services/route_service.dart';
import 'package:bikynav/features/route/presentation/widgets/custom_data_display.dart';
import 'package:bikynav/shared/ui/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// Importaciones de tus blocs y widgets
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/presentation/views/views.dart';
import 'package:bikynav/features/nav/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;
  bool _isMenuOpen = false;
  bool isRouteStart = false;
  GoogleMapController? _mapController;
  bool _initialCameraMoveDone = false;
  MapType currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      locationBloc = BlocProvider.of<LocationBloc>(context);
      locationBloc.startFollowingUser(); // Mover aquí la llamada
    });
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  void toggleMapType() {
  setState(() {
    currentMapType = currentMapType == MapType.normal 
        ? MapType.satellite 
        : MapType.normal;
  });
}

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => ZoomIn(
            child: AlertDialog(
              title: const Text('¿Salir de la aplicación?', textAlign: TextAlign.center),
              content: const Text('¿Estás seguro de que quieres salir?', textAlign: TextAlign.center,),
              backgroundColor: Colors.white,
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Sí'),
                ),
              ],
            ),
          ),
        ) ??
        false; // Si el diálogo se cierra sin elegir una opción, devuelve false
  }

  @override
  Widget build(BuildContext context) {
    
    return PopScope(
      canPop: false, // Inicialmente no permitimos el pop por defecto
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        bool shouldPop = await _onWillPop();
        if (shouldPop) {
          Navigator.of(context).pop(); // Realizamos el pop manualmente si el usuario elige "Sí"
        }
      }, 
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, locationState) {
                if (locationState.lastKnowlocation == null) {
                  return _loader();
                }
                return BlocBuilder<MapBloc, MapState>(
                  builder: (context, mapState) {
                    Map<String, Polyline> polylines = Map.from(mapState.polylines);
                    if (!mapState.showMyRoute) {
                      polylines.removeWhere((key, value) => key == 'myRoute');
                    }

                    final searchState = BlocProvider.of<SearchBloc>(context, listen: false);

                    return SingleChildScrollView(
                      child: Stack(
                        children: [
                          MapView(
                            initialLocation: locationState.lastKnowlocation!,
                            polylines: polylines.values.toSet(),
                            markers: mapState.markers.values.toSet(),
                            mapType: currentMapType,
                            
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                              context.read<MapBloc>().add(OnMapInitializedEvent(controller));
                              // Mover la cámara a la ubicación inicial de la ruta si está cargada al inicio
                              if (mapState.onInitRoute || mapState.onSelectRoute && mapState.polylines.containsKey('route') && mapState.polylines['route']!.points.isNotEmpty && !_initialCameraMoveDone) {
                                final initialRouteLocation = mapState.polylines['route']!.points.first;
                                _mapController?.animateCamera(CameraUpdate.newLatLng(initialRouteLocation));
                                setState(() {
                                  _initialCameraMoveDone = true;
                                });
                              }
                              if (mapState.onInitRoute || mapState.onSelectRoute && mapState.polylines.containsKey('myRoute') && mapState.polylines['myRoute']!.points.isNotEmpty && !_initialCameraMoveDone) {
                                final initialRouteLocation = mapState.polylines['myRoute']!.points.first;
                                _mapController?.animateCamera(CameraUpdate.newLatLng(initialRouteLocation));
                                setState(() {
                                  _initialCameraMoveDone = true;
                                });
                              }
                            },
                          ),
                          if (mapState.onInitRoute || mapState.onSelectRoute)
                            const Positioned(
                              top: 50,
                              right: 20,
                              child: BtnCancelRoute(),
                            ),
                          Positioned(
                            bottom: 120,
                            left: 0,
                            right: 0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!searchState.state.displayManualMarker)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    spacing: 5,
                                    children: [
                                      
                                      if(mapState.onSelectRoute)  
                                        FilledButton.icon(
                                          onPressed: () async {
                                            final routeServices = Provider.of<RouteServices>(context, listen: false);
                                            final mapBloc = BlocProvider.of<MapBloc>(context, listen: false);
                                            final currentLocation = locationState.lastKnowlocation!;
                                            final routeStart = routeServices.myRoute.ubicacionInicial!;
                                            final navigationPath = await searchState.getCoorsStartToEnd(
                                              currentLocation, 
                                              routeStart
                                            );
                                            
                                            // 4. Dibujamos la ruta de navegación (con IDs distintos)
                                            await mapBloc.drawRoutePolyline(navigationPath);
                                          }, 

                                          label: const Text('Como llegar'),
                                          icon: const Icon(Icons.directions),
                                          style: ButtonStyle(
                                            minimumSize: WidgetStatePropertyAll(Size(155, 45)),
                                          ),
                                        ),
                                      if(mapState.onInitRoute)
                                        const BtnFollowUser(), 
                                      Padding(
                                        padding: const EdgeInsets.only( right:  10),
                                        child: Column(
                                          children: [
                                            CustomChangeMapView( onPressed: toggleMapType, currentMapType: currentMapType,),
                                            
                                            const BtnCurrentLocation(),
                                          ],
                                        ),
                                      ),
                                    ]
                                  ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -25,
                            right: 0,
                            left: 0,
                            child: (mapState.onInitRoute || mapState.onSelectRoute)
                                  ? const CustomDataDisplay()
                                  : const CustomSearchBar(),
                            ),
                          const ManualMarker(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            // Aquí está el SideMenu dentro de un Positioned en el Stack.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: SideMenu( // Usamos el nuevo widget
                isMenuOpen: _isMenuOpen,
                onClose: () {
                  setState(() {
                    _isMenuOpen = false;
                  });
                },
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: _isMenuOpen
            ? null
            : Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: Color.fromARGB(200, 255, 255, 255),
                      onPressed: () {
                        setState(() {
                          _isMenuOpen = true; // Abre el menú
                        });
                      },
                      child: const Icon(Icons.menu, color: Colors.deepPurple,),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
      ),
    );
  }

  Center _loader() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,   // Centra verticalmente
        crossAxisAlignment: CrossAxisAlignment.center,   // Centra horizontalmente
        children: [
          Text('Espere por favor...'),
          SizedBox(height: 10),   // Añade un espacio entre los textos
          CircularProgressIndicator(),
          SizedBox(height: 10),   // Añade un espacio entre el progreso y el texto
          Text('Estamos calculando su ubicación...'),
        ],
      ),
    );
  }
}