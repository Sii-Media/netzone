part of 'get_complaint_bloc.dart';

abstract class GetComplaintState extends Equatable {
  const GetComplaintState();

  @override
  List<Object> get props => [];
}

class GetComplaintInitial extends GetComplaintState {}

class GetComplaintInProgress extends GetComplaintState {}

class GetComplaintSuccess extends GetComplaintState {
  final List<Complaints> complaints;

  const GetComplaintSuccess({required this.complaints});
}

class GetComplaintFailure extends GetComplaintState {
  final String message;

  const GetComplaintFailure({required this.message});
}
