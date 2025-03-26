import 'package:bikynav/features/bikes/app/services/bike_services.dart';
import 'package:bikynav/features/bikes/config/models/bike_model.dart';
import 'package:bikynav/features/bikes/presentation/views/show_bike_details.dart';
import 'package:bikynav/shared/ui/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

class BikesScreen extends StatefulWidget {
  const BikesScreen({super.key});

  @override
  State<BikesScreen> createState() => _BikesScreenState();
}

class _BikesScreenState extends State<BikesScreen> {
  late Future<void> _imagePrecacheFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imagePrecacheFuture = _precacheImages(context);
  }

  Future<void> _precacheImages(BuildContext context) async {
    List<String> imageAssets = [
      'assets/images/ruta.png',
      'assets/images/mtb.png',
      'assets/images/urbana.png',
      'assets/images/noimage.jpg',
    ];

    for (String asset in imageAssets) {
      await precacheImage(AssetImage(asset), context);
    }
  }

@override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _imagePrecacheFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final bikeServices = Provider.of<BikeServices>(context);
          List<Bikes> bikes = _getBikes(bikeServices.bikes);
          Map<String, List<Bikes>> groupedBikes = _groupBikesByType(bikes);

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: _buildAppBar(),
              ),
            ),
            body: _bodyBikeScreen(groupedBikes, context),
            bottomNavigationBar: const BuildBottomNavigationBar(),
          );
        } else {
          return const Center(child: CircularProgressIndicator( backgroundColor: Colors.white,));
        }
      },
    );
  }

Padding _bodyBikeScreen(Map<String, List<Bikes>> groupedBikes, BuildContext context) {
  return Padding(
            padding: EdgeInsets.zero,
            child: ListView(
              children: groupedBikes.entries.map((entry) {
                Map<String, String> bikeTypeBackgrounds = {
                  'Ruta': 'assets/images/ruta.png',
                  'MTB': 'assets/images/mtb.png',
                  'Urbana': 'assets/images/urbana.png',
                };
                String backgroundImage = bikeTypeBackgrounds[entry.key] ?? 'assets/images/noimage.jpg';
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(backgroundImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildBikeRow(entry.value, entry.key, context),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
}

  Widget _buildBikeRow(List<Bikes> bikes, String bikeType, BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: bikes.map((bike) => _bikesList(bike, context)).toList(),
        ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Bicicletas'),
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
    );
  }

  List<Bikes> _getBikes(List<dynamic> bikesData) {
    return bikesData.map<Bikes>((bike) {
      if (bike is Map<String, dynamic>) {
        return Bikes.fromJson(bike);
      } else if (bike is Bikes) {
        return bike;
      } else {
        return Bikes();
      }
    }).toList();
  }

  Map<String, List<Bikes>> _groupBikesByType(List<Bikes> bikes) {
    Map<String, List<Bikes>> groupedBikes = {};
    for (var bike in bikes) {
      groupedBikes.putIfAbsent(bike.tipo!, () => []).add(bike);
    }
    return groupedBikes;
  }

  GestureDetector _bikesList(Bikes bike, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showBikeDetails(context, bike); // Mostramos el Dialog con los detalles
      },
      child: SlideInRight(
        child: Card(
          shadowColor: Colors.black,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/noimage.jpg',
                  width: 100,
                  height: 140,
                ),
                Text(
                  bike.etiqueta ?? 'Sin etiqueta',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('Marca: ${bike.marca ?? 'Desconocida'}'),
                Text('Aro: ${bike.aro ?? 'Desconocido'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
