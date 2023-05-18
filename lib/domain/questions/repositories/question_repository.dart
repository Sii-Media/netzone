import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/questions/entities/question_response.dart';

abstract class QuestionRepository {
  Future<Either<Failure, QuestionResponse>> addQuestion({
    required final String text,
  });
}
