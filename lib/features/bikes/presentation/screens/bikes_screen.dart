import 'package:bikynav/features/bikes/app/services/bike_services.dart';
import 'package:bikynav/features/bikes/config/models/bike_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BikesScreen extends StatelessWidget {
  const BikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: EdgeInsets.zero,
        child: ListView(
          children: groupedBikes.entries.map((entry) {
            Map<String, String> bikeTypeBackgrounds = {
              'Ruta': 'assets/images/ruta.png', // Imágenes específicas para Ruta
              'MTB': 'assets/images/mtb.png', // Imágenes específicas para MTB
              'Urbana': 'assets/images/urbana.png', // Imágenes específicas para Gravel
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
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildBikeRow(entry.value, entry.key),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBikeRow(List<Bikes> bikes, String bikeType) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: bikes.map((bike) => _bikesList(bike)).toList(),
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

  Widget _buildBottomNavigationBar(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 0,
          blurRadius: 4,
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: BottomAppBar(
      shadowColor: Colors.black,
      height: 65,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context,
            Icons.search,
            'Buscar',
            () => context.push('/search'),
          ),
          VerticalDivider(width: 20, thickness: 1),
          _buildNavItem(
            context,
            Icons.add_circle,
            'Agregar',
            () => context.push('/add_bike'),
            color: Colors.deepPurple,
          ),
        ],
      ),
    ),
  );
}

Widget _buildNavItem(BuildContext context, IconData icon, String label, VoidCallback onPressed, {Color? color}) {
  return InkWell(
    onTap: onPressed,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        Text(label),
      ],
    ),
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

  Card _bikesList(Bikes bike) {
    return Card(
      shadowColor: Colors.black,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
    );
  }
}
