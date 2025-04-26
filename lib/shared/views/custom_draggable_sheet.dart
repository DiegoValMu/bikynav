import 'package:animate_do/animate_do.dart';
import 'package:bikynav/features/nav/app/blocs/search/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CustomDraggableSheet extends StatefulWidget {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  const CustomDraggableSheet({
    super.key,
    this.minHeight = 100,
    this.maxHeight = 450,
    required this.child,
  });

  @override
  State<CustomDraggableSheet> createState() => _CustomDraggableSheetState();
}

class _CustomDraggableSheetState extends State<CustomDraggableSheet> {
  double _height = 100;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return (state.displayManualMarker || state.displayManualPinMarker)
          ? const SizedBox()
          : FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: _DraggableSheetBody(
                height: _height,
                minHeight: widget.minHeight,
                maxHeight: widget.maxHeight,
                onHeightChanged: (double newHeight) {
                  setState(() {
                    _height = newHeight.clamp(widget.minHeight, widget.maxHeight);
                  });
                },
                child: widget.child,
              ),
            );
      },
    );
  }
}

class _DraggableSheetBody extends StatelessWidget {
  final double height;
  final double minHeight;
  final double maxHeight;
  final ValueChanged<double> onHeightChanged;
  final Widget child;

  const _DraggableSheetBody({
    required this.height,
    required this.minHeight,
    required this.maxHeight,
    required this.onHeightChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: (details) {
          if (height < maxHeight - 10) {
            final newHeight = height - details.delta.dy;
            onHeightChanged(newHeight.clamp(minHeight, maxHeight));
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            onHeightChanged(maxHeight);
          } else {
            onHeightChanged(minHeight);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}