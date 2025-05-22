import 'package:bikynav/app/blocs/blocs.dart';
import 'package:bikynav/app/services/marker_service.dart';
import 'package:bikynav/config/models/markers_model.dart';
import 'package:bikynav/presentation/shared/views/custom_draggable_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CustomMarkerDataDisplay extends CustomDraggableSheet {
  final VoidCallback onCloseTap;
  final VoidCallback onTallerTap;
  
  CustomMarkerDataDisplay({
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
    final markerServices = Provider.of<MarkerServices>(context, listen: false); 

    return Column(
      children: [
        const DecorativeBar(),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: titleAndClose(markerServices, mapBloc),
        ),
        const Divider(),
         _tallerListActualCity(markerServices.infoMarkers),
        
      ],
    );
  }

 Expanded _tallerListActualCity(List<Markers> infoMarkers) {
  final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
  final locationBloc = BlocProvider.of<LocationBloc>(context, listen: false);
  
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
          final tallerInfo = infoMarkers[index];
          final posTaller = LatLng(tallerInfo.pos![0], tallerInfo.pos![1]);
          
          return FutureBuilder(
            future: searchBloc.getCoorsStartToEnd(
              locationBloc.state.lastKnowlocation!, 
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
                  title: Text('${tallerInfo.etiqueta}'),
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
                  title: Text('${tallerInfo.etiqueta}'),
                  subtitle: const Text('Error al obtener datos'),
                );
              }
              
              if (!snapshot.hasData) {
                return ListTile(
                  title: Text('${tallerInfo.etiqueta}'),
                  subtitle: const Text('Datos no disponibles'),
                );
              }
              
              final data = snapshot.data!;
              final distance = (data.distance ?? 0) / 1000; // metros a km con valor por defecto
              final tripDuration = (data.duration ?? 0) / 60; // segundos a minutos con valor por defecto
              
              
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${tripDuration.floor()} min', style: const TextStyle(fontSize: 13)),
                    Text('${distance.toStringAsFixed(1)} km', style: const TextStyle(fontSize: 13)),
                  ],
                ),
                title: Text('${tallerInfo.etiqueta}'),
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

  Row titleAndClose(MarkerServices markerServices, MapBloc mapBloc){
    
    final markerServices = Provider.of<MarkerServices>(context, listen: false); 
    final actualDataPlace = markerServices.dataActualPlace;

    String? markerType;


    if(mapBloc.state.onSelectTallerMarker){
      markerType = 'Talleres';
    }
    if(mapBloc.state.onSelectEventMarker){
      markerType = 'Eventos';
    }

    

    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListTile(
                leading: IconButton(
                  onPressed: (){

                  }, 
                  icon: const Icon(Icons.info),
                  iconSize: 37,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                  
                title: Text('${markerType} en ${actualDataPlace!.properties.placeFormatted.split(',').first}', 
                  style: const TextStyle(fontSize: 18),),
                
              )),
            IconButton(
              onPressed: (){
                markerServices.infoMarkers.clear();
                mapBloc.state.markers.clear();
                
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

class DecorativeBar extends StatelessWidget {
  const DecorativeBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Center(
        child: Container(
          height: 5,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}