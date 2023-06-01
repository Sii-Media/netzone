import 'package:netzoon/data/datasource/remote/send_email/send_email_remote_data_sourse.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../domain/send_emails/repositories/send_email_repository.dart';
import '../../core/utils/network/network_info.dart';

class SendEmailRepositoryImpl implements SendEmailRepository {
  final NetworkInfo networkInfo;
  final SendEmailRemoteDataSource sendEmailRemoteDataSource;

  SendEmailRepositoryImpl(
      {required this.networkInfo, required this.sendEmailRemoteDataSource});
  @override
  Future<Either<Failure, String>> sendEmail(
      {required String name,
      required String email,
      required String subject,
      required String message}) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await sendEmailRemoteDataSource.sendEmail(
            name, email, subject, message);
        return Right(response);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
