import 'package:bikynav/app/helpers/real_time_provider.dart';
import 'package:bikynav/presentation/shared/views/custom_draggable_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/custom_decorative_bar.dart';
import '../widgets/btn_save_route.dart';

class SaveRouteDisplay extends CustomDraggableSheet {
  SaveRouteDisplay({super.key}) : super(
    minHeight: 100,
    maxHeight: 450,
    child: const _SaveRouteDisplayContent(),
  );
}

class _SaveRouteDisplayContent extends StatefulWidget {
  const _SaveRouteDisplayContent();

  @override
  State<_SaveRouteDisplayContent> createState() => _SaveRouteDisplayContentState();
}

class _SaveRouteDisplayContentState extends State<_SaveRouteDisplayContent> {
  @override
  void initState() {
    super.initState();
    Provider.of<StopwatchProvider>(context, listen: false).startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final stopwatch = Provider.of<StopwatchProvider>(context);
    final seconds = stopwatch.elapsedSeconds;
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final displaySeconds = (seconds % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        const DecorativeBar(),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ListTile(
            leading: _buildTimerDisplay(minutes, displaySeconds),
            title: const BtnSaveRoute(),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerDisplay(String minutes, String seconds) {
    return SizedBox(
      width: 80,
      child: Row(
        children: [
          const Icon(Icons.timelapse, size: 15),
          const SizedBox(width: 3),
          Text('$minutes:$seconds', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}