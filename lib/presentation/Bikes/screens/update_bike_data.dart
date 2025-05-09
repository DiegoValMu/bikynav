import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bikynav/app/services/bike_services.dart';
import 'package:bikynav/presentation/Bikes/views/bike_form.dart'; // Importa el nuevo widget

class UpdateBikeDataScreen extends StatelessWidget {
  final dynamic bike; // Recibe un objeto Bikes

  const UpdateBikeDataScreen({super.key, required this.bike});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                offset: Offset(0, 0),
                blurRadius: 6,
              ),
            ],
          ),
          child: _buildAppBar(context),
        ),
      ),
      body: BikeForm(
        bike: bike,
        buttonText: 'Guardar',
        onSubmit: (bikeData) async {
          final bikeServices = Provider.of<BikeServices>(context, listen: false);
          try {
            await bikeServices.bikeRegister(bikeData); // Aquí deberías tener un método para actualizar, no registrar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Información de la bicicleta actualizada correctamente")),
            );
            Navigator.of(context).pop();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Problemas con el servicio: $e")),
            );
          }
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Implementar lógica de eliminación
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ],
      title: const Text('Editar Información'),
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
    );
  }
}