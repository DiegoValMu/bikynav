import 'package:animate_do/animate_do.dart';
import 'package:bikynav/app/helpers/helpers.dart';
import 'package:bikynav/app/services/marker_service.dart';
import 'package:bikynav/presentation/Navegacion/views/custom_marker_data_view.dart';
import 'package:bikynav/presentation/Navegacion/widgets/custom_change_map_view.dart';
import 'package:bikynav/presentation/Navegacion/views/custom_marker_form.dart';
import 'package:bikynav/app/services/route_service.dart';
import 'package:bikynav/presentation/Rutas/views/custom_routes_data_display.dart';
import 'package:bikynav/presentation/Rutas/widgets/custom_data_display.dart';
import 'package:bikynav/presentation/shared/ui/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// Importaciones de tus blocs y widgets
import 'package:bikynav/app/blocs/blocs.dart';
import 'package:bikynav/presentation/Navegacion/views/views.dart';
import 'package:bikynav/presentation/Navegacion/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;
  late MarkerServices markerServices;
  late RouteServices routeServices;
  bool _isMenuOpen = false;
  bool isRouteStart = false;
  GoogleMapController? _mapController;
  bool _initialCameraMoveDone = false;
  MapType currentMapType = MapType.normal;
  bool steps = false;
  bool markerOn = false;
  late List<dynamic> infoMarkers = [];

  bool onSelectTallerMarkers = false;
  bool onSelectEventMarkers = false;
  bool onSelectRoutesMarkers = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      locationBloc = BlocProvider.of<LocationBloc>(context);
      locationBloc.startFollowingUser(); // Mover aquí la llamada

      
    });
  }

  void _handleMarkerAdded() {
    setState(() {
      markerOn = true;
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
        if (_isMenuOpen) {
          setState(() => _isMenuOpen = false);
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
                    markerServices = Provider.of<MarkerServices>(context, listen: false); 
                    routeServices = Provider.of<RouteServices>(context, listen: false); 

                    if(markerServices.infoMarkers.isNotEmpty){
                      context.read<MapBloc>().updateCurrentMarkerPosition(context);
                    }

                    if(routeServices.rutas2.isNotEmpty){
                      context.read<MapBloc>().updateRoutesMarkerPosition(context);
                    }

                    if(mapState.onSelectTallerMarker){
                      onSelectTallerMarkers = true;
                    }

                    if(mapState.onSelectEventMarker){
                      onSelectEventMarkers = true;
                    }

                    if(mapState.onSelectRoutes){
                      
                      onSelectRoutesMarkers = true;
                    }

                    return Stack(
                      children: [
                        MapView(
                          initialLocation: locationState.lastKnowlocation!,
                          polylines: polylines.values.toSet(),
                          markers: mapState.markers.values.toSet(),
                          mapType: currentMapType,
                          onLongPress: (p0) {
                            markerServices.infoMarkers.clear();
                            
                            context.read<MapBloc>().add(OnCancelTallerMarker());
                            context.read<MapBloc>().add(OnCancelEventMarker());
                            onSelectTallerMarkers = false;
                            onSelectEventMarkers = false;
                            _setMarker(context, p0, _handleMarkerAdded);
                            
                          },
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                            context.read<MapBloc>().add(OnMapInitializedEvent(controller));
                            // Mover la cámara a la ubicación inicial de la ruta si está cargada al inicio
                            if (mapState.onInitRoute || mapState.onSelectRoute && mapState.polylines.containsKey('route') && mapState.polylines['route']!.points.isNotEmpty && !_initialCameraMoveDone) {
                              final initialRouteLocation = mapState.polylines['route']!.points.first;
                              _mapController?.animateCamera(CameraUpdate.newLatLng(initialRouteLocation));
                              setState(() => _initialCameraMoveDone = true);
                            }
                            if (mapState.onInitRoute || mapState.onSelectRoute && mapState.polylines.containsKey('myRoute') && mapState.polylines['myRoute']!.points.isNotEmpty && !_initialCameraMoveDone) {
                              final initialRouteLocation = mapState.polylines['myRoute']!.points.first;
                              _mapController?.animateCamera(CameraUpdate.newLatLng(initialRouteLocation));
                              setState(() => _initialCameraMoveDone = true);
                            }
                          },
                        ),
                        if (mapState.onInitRoute)
                          Positioned(
                            top: 50,
                            right: 20,
                            child: BtnCancelRoute( 
                              steps: steps,
                              onCancel: () { 
                                steps = false;
                                //markerOn = true;
                                } 
                            )
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
                              ZoomIn(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  spacing: 5,
                                  children: [
                                    if(mapState.onInitRoute && !mapState.showMyRoute )
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
                              ),
                            ],
                          ),
                        ),

                        //Display de los diferentes menus

                        if(onSelectTallerMarkers || onSelectEventMarkers)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: SlideInUp(child: CustomMarkerDataDisplay(
                              onCloseTap: () => setState(() { 
                                onSelectTallerMarkers = false;
                                onSelectEventMarkers = false;
                                context.read<MapBloc>().add(OnCancelTallerMarker());
                                context.read<MapBloc>().add(OnCancelEventMarker());
                                
                                
                              }),
                              onTallerTap: () {
                                onSelectTallerMarkers = false;
                                onSelectEventMarkers = false;


                              } 
                            ))
                          ),

                        if(onSelectRoutesMarkers)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: SlideInUp(child: CustomRoutesDataDisplay(
                              onCloseTap: () => setState(() { 
                                onSelectRoutesMarkers = false;
                                context.read<MapBloc>().add(OnCancelTallerMarker());
                                context.read<MapBloc>().add(OnCancelEventMarker());
                                context.read<MapBloc>().add(OnCancelRoutes());
                                context.read<MapBloc>().add(InCancelRoutes());
                                context.read<MapBloc>().state.markers.clear();
                                
                              }),
                              onTallerTap: () {
                                

                              } 
                            ))
                          ),
                        
                        if(markerOn)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: SlideInUp(child: CustomMarkerForm(
                              onCloseTap: () => setState(() { 
                                markerOn = false;
                                final mapBloc = BlocProvider.of<MapBloc>(context, listen: false);
                                mapBloc.add( OnCancelRoute() );
                                mapBloc.add(OnStopFollowingUserEvent());
                                if (mapState.polylines.isNotEmpty){
                                  mapState.polylines.remove('navigationRoute');
                                  mapState.markers.remove('navigationStart');
                                  mapState.markers.remove('navigationEnd');
                                }
                              }),
                              onRouteTap: () {
                                markerOn = false;

                              } 
                            ))
                          ),
                          if(!markerOn && !isRouteStart && !onSelectTallerMarkers & !onSelectEventMarkers & !onSelectRoutesMarkers)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: (mapState.onInitRoute || mapState.onSelectRoute)//acaaa
                              ? SlideInUp(child: CustomDataDisplay())
                              : SlideInUp(child: CustomSearchBar(
                                    onMenuPressed: () => setState(() => _isMenuOpen = true),
                                )),
                          ),
                        //
                        //const ManualPinMarker(),
                        const ManualMarker(),
                      ],
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

_setMarker(BuildContext context, LatLng p0, VoidCallback onMarkerAdded) async {

  

  showLoadingMessage(context);

  final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
  final mapBloc = BlocProvider.of<MapBloc>(context, listen: false);
  final routeServices = Provider.of<RouteServices>(context, listen: false);
  final markerServices = Provider.of<MarkerServices>(context, listen: false); 

  mapBloc.state.markers.clear();

  if (mapBloc.state.polylines.isNotEmpty){
    mapBloc.add( OnCancelRoute() );
    mapBloc.add(OnStopFollowingUserEvent());
    mapBloc.state.polylines.remove('navigationRoute');
    mapBloc.state.markers.remove('navigationStart');
    mapBloc.state.markers.remove('navigationEnd');
  }

  final placeData = await searchBloc.getInformationPlace(p0);
  
  routeServices.infoPlace = placeData;

  final newMarker = Marker(
    markerId: MarkerId(placeData.id), // ID diferente
    position: p0,
    infoWindow:  InfoWindow(title: placeData.properties.name),
    anchor: const Offset(0.5, 1.0),
  );

  markerServices.setMarker = newMarker;

  final updatedMarkers = Map<String, Marker>.from(mapBloc.state.markers);
  updatedMarkers[newMarker.markerId.value] = newMarker;
  hideLoadingMessage(context);

  mapBloc.add(DisplayMarkerEvent(updatedMarkers));
  mapBloc.add(MoveCameraToLocationEvent(p0));

  
  onMarkerAdded();

}