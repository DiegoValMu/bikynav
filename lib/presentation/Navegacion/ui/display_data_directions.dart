import 'package:bikynav/app/blocs/map/map_bloc.dart';
import 'package:bikynav/app/blocs/search/search_bloc.dart';
import 'package:bikynav/config/models/models.dart';
import 'package:bikynav/app/services/route_service.dart';
import 'package:bikynav/presentation/shared/views/custom_draggable_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../widgets/decorative_bar.dart';


class DirectionDisplay extends CustomDraggableSheet {
  final String id;
  
  DirectionDisplay({super.key, required this.id}) : super(
    minHeight: 100,
    maxHeight: 450,
    child: _DirectionDisplayContent(id: id),
  );
}

class _DirectionDisplayContent extends StatefulWidget {
  final String id;
  const _DirectionDisplayContent({required this.id});

  @override
  State<_DirectionDisplayContent> createState() => _DirectionDisplayContentState();
}

class _DirectionDisplayContentState extends State<_DirectionDisplayContent> {
  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final routeServices = Provider.of<RouteServices>(context);

    final feature = searchBloc.state.history.firstWhere(
      (f) => f.id == routeServices.selectNavRoute,
      orElse: () => searchBloc.state.history.first,
    );

    final name = feature.properties.name;
    final distance = feature.properties.distancia ?? 0;
    final tripDuration = (feature.properties.duracion ?? 0) / 60;

    return Column(
      children: [
        const DecorativeBar(),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ListTile(
            leading: _buildDirectionInfo(tripDuration, distance),
            title: _buildTitle(name, false),
            trailing: _buildCloseButton(mapBloc),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        // ... resto del contenido específico para direcciones
      ],
    );
  }
  

   Widget _buildDirectionInfo(double duration, double distance) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Row(children: [
            const Icon(Icons.timelapse, size: 15),
            const SizedBox(width: 3),
            Text('$duration min', style: const TextStyle(fontSize: 12)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.flag, size: 15),
            const SizedBox(width: 8),
            Text('$distance km', style: const TextStyle(fontSize: 12)),
          ]),
        ],
      ),
    );
  }

  Widget _buildTitle(String name, bool isRoute) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRoute ? 'Ruta' : 'Dirección',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(name, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildCloseButton(MapBloc mapBloc) {
    return IconButton(
      icon: const Icon(Icons.close, size: 24),
      onPressed: () => _clearRoute(mapBloc),
    );
  }

  void _clearRoute(MapBloc mapBloc) {
    mapBloc.add(OnCancelRoute());
    mapBloc.state.polylines.remove('myRoute');
    mapBloc.state.polylines.remove('route');
    mapBloc.state.markers.remove('start');
    mapBloc.state.markers.remove('end');
  }
  // ... (métodos similares a RouteDisplay pero para direcciones)
}