part of 'add_openion_bloc.dart';

abstract class AddOpenionState extends Equatable {
  const AddOpenionState();

  @override
  List<Object> get props => [];
}

class AddOpenionInitial extends AddOpenionState {}

class AddOpenionInProgress extends AddOpenionState {}

class AddOpenionSuccess extends AddOpenionState {
  final Openion openion;

  const AddOpenionSuccess({required this.openion});
}

class AddOpenionFailure extends AddOpenionState {
  final String message;
  final Failure failure;
  const AddOpenionFailure({
    required this.message,
    required this.failure,
  });
}
