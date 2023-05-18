part of 'add_openion_bloc.dart';

abstract class AddOpenionEvent extends Equatable {
  const AddOpenionEvent();

  @override
  List<Object> get props => [];
}

class PostOpenionEvent extends AddOpenionEvent {
  final String text;

  const PostOpenionEvent({required this.text});
}
