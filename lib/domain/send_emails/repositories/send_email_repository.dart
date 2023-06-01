import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class SendEmailRepository {
  Future<Either<Failure, String>> sendEmail({
    required final String name,
    required final String email,
    required final String subject,
    required final String message,
  });
}
