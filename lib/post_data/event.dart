import 'package:equatable/equatable.dart';

abstract class PostDataEvent extends Equatable{
  const PostDataEvent();
  @override
  List<Object?> get props => [];
}

class InitEvent extends PostDataEvent {

}
class PostEvent extends PostDataEvent {
 final String? problemTitle;
 final String? problemDescription;
 final  String? problemLocation;
 final  String? date;

  const PostEvent(
      {this.problemTitle,
        this.problemDescription,
        this.problemLocation,
        this.date});
}