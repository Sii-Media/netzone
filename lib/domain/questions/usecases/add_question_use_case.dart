import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/questions/entities/question_response.dart';
import 'package:netzoon/domain/questions/repositories/question_repository.dart';

class AddQuestionUseCase extends UseCase<QuestionResponse, AddQuestionParams> {
  final QuestionRepository questionRepository;

  AddQuestionUseCase({required this.questionRepository});
  @override
  Future<Either<Failure, QuestionResponse>> call(AddQuestionParams params) {
    return questionRepository.addQuestion(text: params.text);
  }
}

class AddQuestionParams {
  final String text;

  AddQuestionParams({required this.text});
}
