import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/config/models/models.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {

SearchDestinationDelegate():super(
  searchFieldLabel: 'Buscar...'
);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){
          query = '';
        }, 
        icon: const Icon( Icons.clear ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        final result = SearchResult(cancel: true);
        close(context, result);
      }, 
      icon: const Icon( Icons.arrow_back));
  }


//Resultados de busqueda en el CustomSearchBar
  @override
  Widget buildResults(BuildContext context) {

    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final proximity = BlocProvider.of<LocationBloc>(context).state.lastKnowlocation!;

    searchBloc.getPlacesByQuery( proximity, query );

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state){
        final places = state.places;
        return ListView.separated(
          itemBuilder: (context, i){
            final place = places[i];
            final destino = LatLng( place.properties.coordinates.longitude, place.properties.coordinates.latitude);
            return ListTile(
              title: Text( place.properties.name, style: const TextStyle( fontSize: 20) ),
              subtitle: Text( place.properties.placeFormatted),
              leading: const Icon ( Icons.place_outlined, color: Colors.black),
              //trailing: Text( '${place.properties.distancia}km' ),
              onTap: (){
                final result = SearchResult(
                  cancel: false, 
                  manual: false,
                  position: destino,
                  name: place.properties.name,
                  description: place.properties.placeFormatted
                  );

                 
                //TODO: agregar place al history
                //searchBloc.add( AddToHistoryEvent( place ) );

                close(context, result);
              },
            );
          }, 
          separatorBuilder: ( context, i) => const Divider(), 
          itemCount: places.length);
      },
    );
  }

//Opcion para señalar ubicacion manualmente
  @override
  Widget buildSuggestions(BuildContext context) {

    final history = BlocProvider.of<SearchBloc>(context).state.history;

    return ListView(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(top: 10, left: 15),
          leading: const Icon( Icons.location_on_outlined),
          title: const Text('Señalar la ubicación en el mapa',),
          onTap: (){
            final result = SearchResult(cancel: false, manual: true);
            close(context, result);

          },
        ),

        history.isEmpty 
          ? Container() 
          : const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Recientes'),
              ),
            ],
          ),
            
        ...history.map((place) => Column(
          children: [
            ListTile(
                title: Text( place.properties.name, style: const TextStyle( fontSize: 20) ),
                subtitle: Text( place.properties.placeFormatted),
                leading: const Icon ( Icons.place_outlined, color: Colors.black),
                //trailing: Text( '${place.properties.distancia}km' ),
                onTap: () {
                  final result = SearchResult(
                    id: place.id, // cambiar para que sea dinamico
                    cancel: false, 
                    manual: false,
                    position: LatLng( place.properties.coordinates.longitude, place.properties.coordinates.latitude),
                    name: place.properties.name,
                    description: place.properties.placeFormatted
                  );

                  close(context, result);
                },
              ),
              const Divider(),
            ],
          ),
           
        ),
        
      ],
    );
  }



}