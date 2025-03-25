import 'package:flutter/material.dart';

class BlinkingCorners extends StatefulWidget {
  @override
  _BlinkingCornersState createState() => _BlinkingCornersState();
}

class _BlinkingCornersState extends State<BlinkingCorners> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true); // Hace que el parpadeo se repita
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final centerWidth = screenSize.width - 120;
    final centerHeight = screenSize.height - 500;
    final cornerSize = 50.0;  // Tamaño de las esquinas
    final borderRadius = 60.0;  // Aumentamos el radio de las esquinas para que sean más redondeadas
    final borderWidth = 4.0;    // Grosor del borde

    return Center(
      child: SizedBox(
        width: centerWidth,
        height: centerHeight,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                // Esquina superior izquierda
                _buildCorner(Alignment.topLeft, 0, 0, cornerSize, borderWidth, borderRadius),
                // Esquina superior derecha
                _buildCorner(Alignment.topRight, 0, 0, cornerSize, borderWidth, borderRadius),
                // Esquina inferior izquierda
                _buildCorner(Alignment.bottomLeft, 0, 0, cornerSize, borderWidth, borderRadius),
                // Esquina inferior derecha
                _buildCorner(Alignment.bottomRight, 0, 0, cornerSize, borderWidth, borderRadius),
              ],
            );
          },
        ),
      ),
    );
  }

  // Método para crear las esquinas
  Widget _buildCorner(
      Alignment alignment,
      double top,
      double left,
      double cornerSize,
      double borderWidth,
      double borderRadius) {
    return Positioned(
      top: alignment == Alignment.topLeft || alignment == Alignment.topRight ? top : null,
      left: alignment == Alignment.topLeft || alignment == Alignment.bottomLeft ? left : null,
      right: alignment == Alignment.topRight || alignment == Alignment.bottomRight ? left : null,
      bottom: alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight ? top : null,
      child: Opacity(
        opacity: _animation.value,
        child: ClipPath(
          clipper: CornerClipper(
            alignment: alignment,
            borderRadius: borderRadius,  // Aplicamos el radio aumentado
            cornerSize: cornerSize,
          ),
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: BoxDecoration(
              color: Colors.transparent, // Sin relleno
              border: Border.all(
                width: borderWidth,
                color: Colors.white, // Solo el borde externo
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// CustomClipper para las esquinas
class CornerClipper extends CustomClipper<Path> {
  final Alignment alignment;
  final double borderRadius;
  final double cornerSize;

  CornerClipper({
    required this.alignment,
    required this.borderRadius,
    required this.cornerSize,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();

    // Dibujar la forma de la esquina
    if (alignment == Alignment.topLeft) {
      path.lineTo(cornerSize, 0); // Horizontal
      path.lineTo(0, cornerSize); // Vertical
    } else if (alignment == Alignment.topRight) {
      path.moveTo(size.width, 0);
      path.lineTo(size.width - cornerSize, 0);
      path.lineTo(size.width, cornerSize);
    } else if (alignment == Alignment.bottomLeft) {
      path.moveTo(0, size.height);
      path.lineTo(cornerSize, size.height);
      path.lineTo(0, size.height - cornerSize);
    } else if (alignment == Alignment.bottomRight) {
      path.moveTo(size.width, size.height);
      path.lineTo(size.width - cornerSize, size.height);
      path.lineTo(size.width, size.height - cornerSize);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
