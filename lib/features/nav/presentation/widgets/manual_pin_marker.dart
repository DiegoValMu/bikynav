import 'package:animate_do/animate_do.dart';
import 'package:bikynav/features/nav/app/blocs/blocs.dart';
import 'package:bikynav/features/nav/presentation/screens/taller_form_screen.dart';
import 'package:bikynav/features/nav/presentation/ui/select_marker_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bikynav/features/nav/app/helpers/helpers.dart';

class ManualPinMarker extends StatelessWidget {
  const ManualPinMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualPinMarker
        ? const _ManualMarkerBody()
        : const SizedBox();
      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final position = locationBloc.state.lastKnowlocation;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          const Positioned(top: 50, right: 20, child: _BtnBack()),
          Center(
            child: Transform.translate(
              offset: const Offset(0, -22),
              child: BounceInDown(
                from: 100,
                child: const Icon(
                  Icons.push_pin_outlined,
                  size: 50,
                  color: Colors.deepPurple,
                  fill: 1,
                )
              )
            ),
          ),
          Positioned(
            bottom: 70,
            left: 40,
            right: 40,
            child: FadeInUp(
              child: MaterialButton(
                minWidth: size.width - 120,
                color: Colors.black,
                elevation: 0,
                height: 50,
                shape: const StadiumBorder(),
                onPressed: () async {
                  final markerPosition = mapBloc.mapCenter;
                  if( markerPosition == null ) return;
                  final res = selectMarkerForm(context);
                  if(res == 'taller'){
                    TallerForm( markerPosition: markerPosition );
                  }
                  
                },
                child: const Text(
                  'Colocar marcador',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                ),
              ),
            )
          ),
        ],
      ),
    );
  }

}



class _BtnBack extends StatelessWidget {
  const _BtnBack();

  void onCancelManualPinMarker(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
      searchBloc.add(OnDesactivateManualPinMarkerEvent());
      return;
  }

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Color.fromARGB(200, 255, 255, 255),
        child: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            onCancelManualPinMarker(context);
          },
        )
      ),
    );
  }
}
