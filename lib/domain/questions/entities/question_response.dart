import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/questions/entities/question.dart';

class QuestionResponse extends Equatable {
  final String message;
  final Question question;

  const QuestionResponse({required this.message, required this.question});
  @override
  List<Object?> get props => [message, question];
}
