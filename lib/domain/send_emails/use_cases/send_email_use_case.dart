import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/send_emails/repositories/send_email_repository.dart';

class SendEmailUseCase extends UseCase<String, SendEmailParams> {
  final SendEmailRepository sendEmailRepository;

  SendEmailUseCase({required this.sendEmailRepository});
  @override
  Future<Either<Failure, String>> call(SendEmailParams params) {
    return sendEmailRepository.sendEmail(
        name: params.name,
        email: params.email,
        subject: params.subject,
        message: params.message);
  }
}

class SendEmailParams {
  final String name;
  final String email;
  final String subject;
  final String message;

  SendEmailParams(
      {required this.name,
      required this.email,
      required this.subject,
      required this.message});
}
