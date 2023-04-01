import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_bloc/model/postModel.dart';
import 'package:flutter_firebase_bloc/service/get_repository.dart';

import 'event.dart';
import 'state.dart';

class RetriveDataBloc extends Bloc<RetriveDataEvent, RetriveDataState> {
final GetApiRepository getApi;
  RetriveDataBloc({required this.getApi}) : super(GetDataLoadingState()) {
    on<GetDataEvent>(_init);
  }

  void _init(GetDataEvent event, Emitter<RetriveDataState> emit) async {
    emit(GetDataLoadingState());
    try {
      final data = await getApi.getData();
      emit(GetDataLoadedState(data));
    } catch (e) {
      emit(GetDataErrorState(e.toString()));
    }
  }
}
