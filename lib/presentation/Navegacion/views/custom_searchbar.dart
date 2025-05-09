import 'package:bikynav/app/blocs/blocs.dart';
import 'package:bikynav/app/delegates/delegates.dart';
import 'package:bikynav/app/helpers/show_loading_message.dart';
import 'package:bikynav/config/models/models.dart';
import 'package:bikynav/presentation/Navegacion/widgets/widgets.dart';
import 'package:bikynav/app/services/route_service.dart';
import 'package:bikynav/presentation/shared/views/custom_draggable_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CustomSearchBar extends CustomDraggableSheet {
  final VoidCallback onMenuPressed;
  
  CustomSearchBar({
    super.key, 
    required this.onMenuPressed,
  }) : super(
    minHeight: 100,
    maxHeight: 450,
    child: _CustomSearchBarContent(
      onMenuPressed: onMenuPressed,
    ),
  );
}

class _CustomSearchBarContent extends StatefulWidget {
  final VoidCallback onMenuPressed;
  
  const _CustomSearchBarContent({
    required this.onMenuPressed,
  });

  @override
  State<_CustomSearchBarContent> createState() => __CustomSearchBarContentState();
}

class __CustomSearchBarContentState extends State<_CustomSearchBarContent> {
  final ScrollController _historyScrollController = ScrollController();

  @override
  void dispose() {
    _historyScrollController.dispose();
    super.dispose();
  }

  void onSearchResult(BuildContext context, SearchResult result) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final routeServices = Provider.of<RouteServices>(context, listen: false);
    
    if (result.manual == true) {
      searchBloc.add(OnActivateManualMarkerEvent());
      return;
    }
    
    if (result.position != null) {
      showLoadingMessage(context);

      final start = locationBloc.state.lastKnowlocation;
      if (start == null) return;

      final position = result.position;
      final end = LatLng(position!.longitude, position.latitude);
      final destination = await searchBloc.getCoorsStartToEnd(start, end);

      await mapBloc.drawRoutePolyline(destination);
      routeServices.selectNavRoute = result.id;
      mapBloc.add(OnInitRoute());

      hideLoadingMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final history = BlocProvider.of<SearchBloc>(context).state.history;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DecorativeBar(),
        _searchAndMenuOptions(context, width),
        _navOptions(history),
        if (history.isNotEmpty)
          _recentSearch(history),
      ],
    );
  }

  Row _searchAndMenuOptions(BuildContext context, double width) {
    return Row(
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
              margin: const EdgeInsets.only(bottom: 20),
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
            padding: const EdgeInsets.only(bottom: 20.0),
            child: IconButton(
              onPressed: widget.onMenuPressed,
              icon: const Icon(Icons.menu, color: Colors.black),
              iconSize: 28,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.grey[200]),
                padding: const WidgetStatePropertyAll(EdgeInsets.all(10)),
              ),
            ),
          ),
        ],
      );
  }

  Flexible _navOptions(List<Feature> history) {
    return Flexible(
        fit: FlexFit.loose,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                const Scrollbar(
                  thickness: 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: NavOptions()),
                ),
                const Divider(),
                if (history.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text('Recientes', textAlign: TextAlign.left),
                  ),
              ],
            ),
          ),
        ),
      );
  }

  Expanded _recentSearch(List<Feature> history) {
    return Expanded(
          flex: 2,
          child: Scrollbar(
            controller: _historyScrollController,
            trackVisibility: true,
            child: ListView.builder(
              controller: _historyScrollController,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: history.length,
              itemBuilder: (context, index) {
                final place = history[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(place.properties.name, 
                        style: const TextStyle(fontSize: 14, height: 1.1)),
                      subtitle: Text(place.properties.placeFormatted,
                        style: const TextStyle(fontSize: 11, height: 1.1)
                      ),
                      minVerticalPadding: 0,
                      visualDensity: VisualDensity.compact,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: -15),
                      leading: const Icon(Icons.place_outlined, color: Colors.black),
                      onTap: () async {
                        final searchBloc = BlocProvider.of<SearchBloc>(context);
                        
                        searchBloc.add(RemoveFromHistory(place.id));
                        
                      
                        final result = SearchResult(
                          id: place.id,
                          cancel: false, 
                          manual: false,
                          position: LatLng(place.properties.coordinates.longitude, place.properties.coordinates.latitude),
                          name: place.properties.name,
                          description: place.properties.placeFormatted
                        );
                        onSearchResult(context, result);
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        );
  }
}