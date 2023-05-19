part of 'add_complaint_bloc.dart';

abstract class AddComplaintEvent extends Equatable {
  const AddComplaintEvent();

  @override
  List<Object> get props => [];
}

class PostComplaintEvent extends AddComplaintEvent {
  final String address;
  final String text;

  const PostComplaintEvent({required this.address, required this.text});
}
