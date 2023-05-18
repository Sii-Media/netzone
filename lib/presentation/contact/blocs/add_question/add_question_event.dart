part of 'add_question_bloc.dart';

abstract class AddQuestionEvent extends Equatable {
  const AddQuestionEvent();

  @override
  List<Object> get props => [];
}

class PostQuestionEvent extends AddQuestionEvent {
  final String text;

  const PostQuestionEvent({required this.text});
}
