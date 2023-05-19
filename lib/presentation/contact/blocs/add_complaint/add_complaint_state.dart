part of 'add_complaint_bloc.dart';

abstract class AddComplaintState extends Equatable {
  const AddComplaintState();

  @override
  List<Object> get props => [];
}

class AddComplaintInitial extends AddComplaintState {}

class AddComplaintInProgress extends AddComplaintState {}

class AddComplaintSuccess extends AddComplaintState {
  final String complaints;

  const AddComplaintSuccess({required this.complaints});
}

class AddComplaintFailure extends AddComplaintState {
  final String message;

  const AddComplaintFailure({required this.message});
}
