import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/questions/question_remote_data_source.dart';
import 'package:netzoon/data/models/questions/question_response_model.dart';
import 'package:netzoon/domain/questions/entities/question_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/questions/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final NetworkInfo networkInfo;
  final QuestionRemoteDataSource questionRemoteDataSource;

  QuestionRepositoryImpl(
      {required this.networkInfo, required this.questionRemoteDataSource});

  @override
  Future<Either<Failure, QuestionResponse>> addQuestion(
      {required String text}) async {
    try {
      if (await networkInfo.isConnected) {
        final question = await questionRemoteDataSource.addQuestion(text);
        return Right(question.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
