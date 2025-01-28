import 'package:flutter/material.dart';
import 'dart:async'; // Necesario para usar Timer

class SlideInfo {
  final String caption;
  final String imageUrl;

  SlideInfo(this.caption, this.imageUrl);
}

final slides = <SlideInfo>[
  SlideInfo('Comencemos!', 'assets/images/home.png'),
  SlideInfo('Navega, guarda y comparte tus rutas', 'assets/images/home1.png'),
  SlideInfo('Disfruta de lugares recomendados', 'assets/images/home2.png')
];

class SlidesView extends StatefulWidget {
  const SlidesView({super.key});

  @override
  State<SlidesView> createState() => _SlidesViewState();
}

class _SlidesViewState extends State<SlidesView> {
  final PageController pageviewController = PageController();
  int currentPage = 0; // Para almacenar la página actual
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    pageviewController.addListener(() {
      final page = pageviewController.page ?? 0;
      setState(() {
        currentPage = page.toInt(); // Actualiza la página actual
      });
    });
  }

  // Inicia el cambio automático de página cada 3 segundos
  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (currentPage < slides.length - 1) {
        pageviewController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        pageviewController.jumpToPage(0); // Regresar al inicio
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Detener el timer cuando se cierre el widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageviewController,
            physics: const BouncingScrollPhysics(),
            children: slides.map(
              (slideData) => _Slide(
                caption: slideData.caption,
                imageUrl: slideData.imageUrl,
              ),
            ).toList(),
          ),
          Positioned(
            bottom: 20, // Ajusta la posición según lo desees
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slides.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: currentPage == index ? 10 : 8, // Tamaño más pequeño
                  height: currentPage == index ? 10 : 8, // Tamaño más pequeño
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPage == index
                        ? const Color.fromARGB(255, 105, 35, 163) // Color para el círculo activo
                        : Colors.grey, // Color para los círculos inactivos
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final String caption;
  final String imageUrl;

  const _Slide({
    required this.caption,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final captionStyle = Theme.of(context).textTheme.titleLarge;

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            Image(image: AssetImage(imageUrl)),
            Text(caption, style: captionStyle),
          ],
        ),
      );
  }
}
