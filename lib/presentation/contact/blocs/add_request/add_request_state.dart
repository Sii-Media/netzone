part of 'add_request_bloc.dart';

abstract class AddRequestState extends Equatable {
  const AddRequestState();

  @override
  List<Object> get props => [];
}

class AddRequestInitial extends AddRequestState {}

class AddRequestInProgress extends AddRequestState {}

class AddRequestSuccess extends AddRequestState {
  final Requests requests;

  const AddRequestSuccess({required this.requests});
}

class AddRequestFailure extends AddRequestState {
  final String message;

  const AddRequestFailure({required this.message});
}
