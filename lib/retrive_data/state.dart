import 'package:equatable/equatable.dart';

import '../model/postModel.dart';

class RetriveDataState extends Equatable {
  const RetriveDataState();

  @override
  List<Object?> get props => [];
}

class GetDataLoadingState extends RetriveDataState {
  @override
  List<Object> get props => [];
}

class GetDataLoadedState extends RetriveDataState {
  final List<FirebaseModel> data;

  const GetDataLoadedState(this.data);

  @override
  List<Object> get props => [data];
}

class GetDataErrorState extends RetriveDataState {
  final String error;

  const GetDataErrorState(this.error);

  @override
  List<Object> get props => [error];
}
