part of 'add_request_bloc.dart';

abstract class AddRequestEvent extends Equatable {
  const AddRequestEvent();

  @override
  List<Object> get props => [];
}

class PostRequestEvent extends AddRequestEvent {
  final String address;
  final String text;

  const PostRequestEvent({required this.address, required this.text});
}
