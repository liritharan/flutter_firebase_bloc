import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_bloc/service/post_repository.dart';
import 'package:flutter_firebase_bloc/view/post_data.dart';

import '../service/notification_service.dart';
import 'event.dart';
import 'state.dart';

class PostDataBloc extends Bloc<PostDataEvent, PostDataState> {
  final PostApiRepository postAPI;
  PostDataBloc({required this.postAPI}) : super(PostInitial()) {


    on<PostEvent>((event, emit) async {
      emit(PostLoading());
      await postAPI.addData(
          event.problemTitle.toString(),
          event.problemDescription.toString(),
          event.problemLocation.toString(),
          event.date.toString());
      emit(const PostSuccess('Your request has been submitted'));
      emit(PostLoaded());
      NotificationService().scheduleNotification(0, event.problemTitle.toString(), event.problemDescription.toString(), );
    });
  }
}
