import 'package:bikynav/app/blocs/blocs.dart';
import 'package:bikynav/app/helpers/real_time_provider.dart';
import 'package:bikynav/presentation/shared/views/custom_draggable_sheet.dart';
import 'package:bikynav/presentation/shared/widgets/decorative_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../widgets/btn_save_route.dart';

class SaveRouteDisplay extends CustomDraggableSheet {
  final VoidCallback onCloseTap;
  SaveRouteDisplay({
    required this.onCloseTap,
    super.key}) : super(
    minHeight: 100,
    maxHeight: 450,
    child:_SaveRouteDisplayContent(onCloseTap: onCloseTap,),
  );
}

class _SaveRouteDisplayContent extends StatefulWidget {
  final VoidCallback onCloseTap;
  const _SaveRouteDisplayContent({
    required this.onCloseTap
  });

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
      mainAxisSize: MainAxisSize.min,
      children: [
        const DecorativeBar(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListTile(
                leading: _buildTimerDisplay(minutes, displaySeconds),
                title: const BtnSaveRoute(),
                contentPadding: EdgeInsets.zero,
                trailing: _onCancelRoute(context),
              ),
            ),
          ],
        ),
        Divider(),
        
      ],
    );
  }

  IconButton _onCancelRoute(BuildContext context) {
    return IconButton(
    onPressed: (){
      final mapBloc = BlocProvider.of<MapBloc>(context, listen: false);
     
      mapBloc.add(OnCancelToggleUserRoute());
      mapBloc.add(OnCancelRoute());
      mapBloc.state.markers.remove('start');
      mapBloc.state.markers.remove('end');
      widget.onCloseTap;
    }, 
    icon: Icon(Icons.close));
  }

  Widget _buildTimerDisplay(String minutes, String seconds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.timer_outlined, size: 18),
        const SizedBox(width: 3),
        Text('$minutes:$seconds min', style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}