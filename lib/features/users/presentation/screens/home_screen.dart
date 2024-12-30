import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bikynav/features/nav/presentation/views/views.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox( height: 20 ),
              const Image( image: AssetImage( 'assets/images/Bienvenidos.png' ) ),
              const Flexible(child: SlidesView()),
              Padding(
                padding: const EdgeInsets.symmetric( horizontal: 10 ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    child: const Text('Iniciar sesión' , style: TextStyle( fontSize: 20),),
                    onPressed: () => context.push('/login'),
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric( horizontal: 10 ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Registrarse' , style: TextStyle( fontSize: 20)),
                    onPressed: () => context.push('/new-user'),
                  ),
                ),
              ),
              const SizedBox( height: 25 ),
              const Text('Al continuar, aceptas las Condiciones del Servicio y la Politica de Privacidad de Bikynav', textAlign: TextAlign.center,),
              const SizedBox( height: 15 ),

            ],
          ),
        ),
      ),
    );
  }
}

