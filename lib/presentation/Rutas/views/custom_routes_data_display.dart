import 'package:bikynav/app/blocs/blocs.dart';
import 'package:bikynav/app/services/marker_service.dart';
import 'package:bikynav/app/services/route_service.dart';
import 'package:bikynav/presentation/shared/views/custom_draggable_sheet.dart';
import 'package:bikynav/presentation/shared/widgets/decorative_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CustomRoutesDataDisplay extends CustomDraggableSheet {
  final VoidCallback onCloseTap;
  final VoidCallback onTallerTap;
  
  CustomRoutesDataDisplay({
    super.key, 
    required this.onCloseTap,
    required this.onTallerTap,
    }) : super(
    minHeight: 100,
    maxHeight: 450,
    child: _CustomDataDisplayContent(
      onCloseTap: onCloseTap,
      onTallerTap: onTallerTap
    ),
  );
}

class _CustomDataDisplayContent extends StatefulWidget {
  final VoidCallback onCloseTap;
  final VoidCallback onTallerTap;

  const _CustomDataDisplayContent({ 
    required this.onCloseTap,
    required this.onTallerTap,
  });

  @override
  State<_CustomDataDisplayContent> createState() => _CustomDataDisplayContentState();
}

class _CustomDataDisplayContentState extends State<_CustomDataDisplayContent> {
  final ScrollController _historyScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final routeServices = Provider.of<RouteServices>(context, listen: false); 

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DecorativeBar(),
        titleAndClose(routeServices, mapBloc),
        const Divider(),
         _routesListActualCity(routeServices.rutas2),
        
      ],
    );
  }

 Expanded _routesListActualCity(List<dynamic> infoMarkers) {
  final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
  final locationBloc = BlocProvider.of<LocationBloc>(context, listen: false);

  final pos = locationBloc.state.lastKnowlocation;

  final dataCity = searchBloc.getInformationPlace(pos!);
  
  return Expanded(
    child: Scrollbar(
      controller: _historyScrollController,
      trackVisibility: true,
      child: ListView.builder(
        itemCount: infoMarkers.length,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        controller: _historyScrollController,
        itemBuilder: (context, index) {
          final routeInfo = infoMarkers[index];
          final posTaller = LatLng(routeInfo["ubicacion_inicial"][0], routeInfo["ubicacion_inicial"][1]);
          
          return FutureBuilder(
            future: searchBloc.getCoorsStartToEnd(
              pos, 
              posTaller
            ),
            builder: (context, snapshot) {
              // Procesamiento seguro de los datos
              
              // Manejo de estados de carga y error
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircularProgressIndicator(
                    strokeWidth: 1,
                    strokeCap: StrokeCap.round,
                  ),
                  title: Text('${routeInfo["etiqueta"]}'),
                  subtitle: const Text('Calculando distancia...'),
                  trailing: TextButton(
                  child: const Icon(Icons.directions, size: 28),
                  onPressed: () {
                    // Acción para abrir direcciones
                  }, 
                ),
                );
              }
              
              if (snapshot.hasError) {
                return ListTile(
                  title: Text('${routeInfo["etiqueta"]}'),
                  subtitle: const Text('Error al obtener datos'),
                );
              }
              
              if (!snapshot.hasData) {
                return ListTile(
                  title: Text('${routeInfo["etiqueta"]}'),
                  subtitle: const Text('Datos no disponibles'),
                );
              }
              
              final data = snapshot.data!;
              final distance = (data.distance ?? 0) / 1000; // metros a km con valor por defecto
              
              
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('a ${distance.toStringAsFixed(1)} km', style: const TextStyle(fontSize: 13)),
                    Text('de ti', style: const TextStyle(fontSize: 13)),
                  ],
                ),
                title: Text('${routeInfo["etiqueta"]}'),
                subtitle: Text(
                  data.endPlace.properties.name != null
                    ? 'Dirección: ${data.endPlace.properties.name}'
                    : 'Dirección no disponible'
                ),
                trailing: TextButton(
                  child: const Icon(Icons.directions, size: 28),
                  onPressed: () {
                    // Acción para abrir direcciones
                  }, 
                ),
              );
            }
          );
        }
      ),
    ),
  );
}

  titleAndClose(RouteServices routeServices, MapBloc mapBloc){
    final locationBloc = BlocProvider.of<LocationBloc>(context, listen: false);
    final pos = locationBloc.state.lastKnowlocation;
    final actualDataPlace = routeServices.infoPlace;
    final markerServices = Provider.of<MarkerServices>(context, listen: false); 

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: IconButton(
              onPressed: (){

              }, 
              icon: const Icon(Icons.info),
              iconSize: 37,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
              
            title: Text('Rutas en ${actualDataPlace!.properties.placeFormatted.split(',').first}', 
              style: const TextStyle(fontSize: 18),),
            
          )),
        IconButton(
          onPressed: (){
            markerServices.setMarker = null;
            markerServices.infoMarkers.clear();
            routeServices.rutas2.clear();
            widget.onCloseTap();
          }, 
          icon: const Icon(Icons.close),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.grey[200]),
            ),
        ),
      ],
    );
    }
  }

