import 'package:bloc/bloc.dart';

import 'event.dart';
import 'state.dart';

class Retrive_dataBloc extends Bloc<Retrive_dataEvent, Retrive_dataState> {
  Retrive_dataBloc() : super(Retrive_dataState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<Retrive_dataState> emit) async {
    emit(state.clone());
  }
}
