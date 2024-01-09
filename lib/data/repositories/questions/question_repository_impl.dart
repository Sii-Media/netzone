import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/local/auth/auth_local_data_source.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
import 'package:netzoon/data/datasource/remote/questions/question_remote_data_source.dart';
import 'package:netzoon/data/models/questions/question_response_model.dart';
import 'package:netzoon/domain/questions/entities/question_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/questions/repositories/question_repository.dart';
import 'package:netzoon/injection_container.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final NetworkInfo networkInfo;
  final QuestionRemoteDataSource questionRemoteDataSource;
  final AuthLocalDatasource local;
  final AuthRemoteDataSource authRemoteDataSource;
  QuestionRepositoryImpl({
    required this.networkInfo,
    required this.questionRemoteDataSource,
    required this.local,
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, QuestionResponse>> addQuestion(
      {required String text}) async {
    try {
      if (await networkInfo.isConnected) {
        final user = local.getSignedInUser();
        if (user != null) {
          if (JwtDecoder.isExpired(user.token)) {
            try {
              if (JwtDecoder.isExpired(user.refreshToken)) {
                local.logout();
                return Left(UnAuthorizedFailure());
              }
            } catch (e) {
              return Left(UnAuthorizedFailure());
            }
            final refreshTokenResponse =
                await authRemoteDataSource.refreshToken(user.refreshToken);
            final newUser = user.copyWith(
                refreshTokenResponse.refreshToken, user.refreshToken);
            await local.signInUser(newUser);
            final dio = sl<Dio>();
            dio.options.headers['Authorization'] = 'Bearer ${newUser.token}';
          }
          final question = await questionRemoteDataSource.addQuestion(text);
          return Right(question.toDomain());
        } else {
          return Left(CredintialFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
