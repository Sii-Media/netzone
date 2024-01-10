part of 'add_question_bloc.dart';

abstract class AddQuestionState extends Equatable {
  const AddQuestionState();

  @override
  List<Object> get props => [];
}

class AddQuestionInitial extends AddQuestionState {}

class AddQuestionInProgress extends AddQuestionState {}

class AddQuestionSuccess extends AddQuestionState {
  final Question question;

  const AddQuestionSuccess({required this.question});
}

class AddQuestionFailure extends AddQuestionState {
  final String message;
  final Failure failure;
  const AddQuestionFailure({
    required this.message,
    required this.failure,
  });
}
