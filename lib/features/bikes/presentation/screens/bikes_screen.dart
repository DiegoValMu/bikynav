import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BikesScreen extends StatelessWidget {
  const BikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Fondo blanco para el AppBar
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Color de la sombra
                offset: Offset(0, 4), // Sombra hacia abajo
                blurRadius: 6, // Difusión de la sombra
              ),
            ],
          ),
          child: _buildAppBar(context)
        ),
      ),
      body: Container(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Bicicletas'),
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () 
          {
            context.push('/add_bike');
          },
          icon: const Icon(Icons.add_circle),
          color: Colors.deepPurple,
        ),
      ],
    );
  }

}