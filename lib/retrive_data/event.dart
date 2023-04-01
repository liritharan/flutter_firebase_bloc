import 'package:equatable/equatable.dart';

abstract class RetriveDataEvent extends Equatable{
  const RetriveDataEvent();

@override
List<Object> get props => [];
}

class GetDataEvent extends RetriveDataEvent {}