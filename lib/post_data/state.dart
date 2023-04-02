import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_bloc/model/postModel.dart';

class PostDataState extends Equatable {
  const PostDataState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostDataState {}

class PostLoading extends PostDataState {}

class PostLoaded extends PostDataState {}

class PostSuccess extends PostDataState {
  final String message;

  const PostSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class PostError extends PostDataState {
  final String error;

  const PostError(this.error);

  @override
  List<Object> get props => [error];
}
