import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'polygon_event.dart';
part 'polygon_state.dart';

class PolygonBloc extends Bloc<PolygonEvent, PolygonState> {



  PolygonBloc() : super(PolygonState()) {
    
    on<PolygonEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
