part of 'get_complaint_bloc.dart';

abstract class GetComplaintEvent extends Equatable {
  const GetComplaintEvent();

  @override
  List<Object> get props => [];
}

class GetComplaintsRequested extends GetComplaintEvent {}
