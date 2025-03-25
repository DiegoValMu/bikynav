import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:bikynav/features/bikes/app/services/bike_services.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:bikynav/features/nav/app/helpers/show_loading_message.dart';
import 'package:bikynav/features/bikes/presentation/views/bike_form.dart'; // Importa el nuevo widget

class AddBikeScreen extends StatelessWidget {
  const AddBikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: _buildAppBar(context),
        ),
      ),
      body: BikeForm(
        buttonText: 'Registrar',
        onSubmit: (bikeData) async {
          final bikeServices = Provider.of<BikeServices>(context, listen: false);
          final userServices = Provider.of<UserServices>(context, listen: false);
          try {
            await bikeServices.bikeRegister(bikeData);
            showLoadingMessage(context);
            await bikeServices.getBikes(userServices.usuario.id!);
            hideLoadingMessage(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Bicicleta registrada correctamente", selectionColor: Colors.white), backgroundColor: Colors.green),
            );
            context.pop(context);
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
      title: const Text('Registrar bicicleta'),
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
    );
  }
}