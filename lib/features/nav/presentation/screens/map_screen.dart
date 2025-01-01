import 'package:bikynav/features/route/presentation/widgets/btn_save_route.dart';
import 'package:bikynav/features/route/presentation/widgets/custom_data_display.dart';
import 'package:bikynav/features/users/presentation/views/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// Importaciones de tus blocs y widgets
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/presentation/views/views.dart';
import 'package:bikynav/features/nav/presentation/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<LocationBloc, LocationState>(
            builder: (context, locationState) {
              if (locationState.lastKnowlocation == null) {
                return const Center(child: Text('Espere por favor...'));
              }
              return BlocBuilder<MapBloc, MapState>(
                builder: (context, mapState) {
                  Map<String, Polyline> polylines = Map.from(mapState.polylines);
                  if (!mapState.showMyRoute) {
                    polylines.removeWhere((key, value) => key == 'myRoute');
                  }
                  if (!mapState.inRoute) {
                    polylines.removeWhere((key, value) => key == 'route');
                  }

                  return SingleChildScrollView(
                    child: Stack(
                      children: [
                        MapView(
                          initialLocation: locationState.lastKnowlocation!,
                          polylines: polylines.values.toSet(),
                          markers: mapState.markers.values.toSet(),
                        ),
                        if (mapState.inRoute)
                          const Positioned(
                            top: 50,
                            right: 20,
                            child: BtnCancelRoute(),
                          ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Padding(
                                    padding: EdgeInsets.only( right: 10 ),
                                    child: BtnCurrentLocation(),
                                ),
                              (mapState.inRoute)
                              ? const CustomDataDisplay()
                              : const CustomSearchBar(),
                            ],
                          ),
                        ),
                        const ManualMarker(),
                      ],
                    ),
                  );
                },
              );
            },
          ),
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
                    onPressed: () {
                      setState(() {
                        _isMenuOpen = true;
                      });
                    },
                    child: const Icon(Icons.menu),
                  ),
                  const SizedBox(height: 15),
                  //const BtnCurrentLocation(),
                  //const BtnFollowUser(),
                  //const BtnToggleUserRoute(),
                ],
              ),
            ),
    );
  }
}