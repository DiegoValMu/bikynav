import 'package:flutter/material.dart';

class BlinkingCorners extends StatefulWidget {
  @override
  _BlinkingCornersState createState() => _BlinkingCornersState();
}

class _BlinkingCornersState extends State<BlinkingCorners>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
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
    final centerWidth = screenSize.width - 150;
    final centerHeight = screenSize.height - 500;
    final cornerSize = 50.0;
    final borderRadius = 30.0;
    final borderWidth = 4.0;

    return Center(
      child: SizedBox(
        width: centerWidth,
        height: centerHeight,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                // Borde superior izquierdo
                Positioned(
                  top: 0,
                  left: 0,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Container(
                      width: cornerSize,
                      height: borderWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Container(
                      width: borderWidth,
                      height: cornerSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          bottomLeft: Radius.circular(borderRadius),
                        ),
                      ),
                    ),
                  ),
                ),
                // Borde superior derecho
                Positioned(
                  top: 0,
                  right: 0,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Container(
                      width: cornerSize,
                      height: borderWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Container(
                      width: borderWidth,
                      height: cornerSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(borderRadius),
                          bottomRight: Radius.circular(borderRadius),
                        ),
                      ),
                    ),
                  ),
                ),
                // Borde inferior izquierdo
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Container(
                      width: cornerSize,
                      height: borderWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(borderRadius),
                          bottomRight: Radius.circular(borderRadius),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Container(
                      width: borderWidth,
                      height: cornerSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          bottomLeft: Radius.circular(borderRadius),
                        ),
                      ),
                    ),
                  ),
                ),
                // Borde inferior derecho
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Container(
                      width: cornerSize,
                      height: borderWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(borderRadius),
                          bottomRight: Radius.circular(borderRadius),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Container(
                      width: borderWidth,
                      height: cornerSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(borderRadius),
                          bottomRight: Radius.circular(borderRadius),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}