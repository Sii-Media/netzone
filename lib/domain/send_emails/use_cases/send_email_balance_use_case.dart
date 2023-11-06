import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/send_emails/repositories/send_email_repository.dart';

class SendEmailBalanceUseCase extends UseCase<String, SendEmailBalanceParams> {
  final SendEmailRepository sendEmailRepository;

  SendEmailBalanceUseCase({required this.sendEmailRepository});
  @override
  Future<Either<Failure, String>> call(SendEmailBalanceParams params) {
    return sendEmailRepository.sendEmailBalance(
        fullName: params.fullName,
        email: params.email,
        balance: params.balance,
        accountName: params.accountName,
        bankName: params.bankName,
        iban: params.iban,
        phoneNumber: params.phoneNumber);
  }
}

class SendEmailBalanceParams {
  final String fullName;
  final String email;
  final double balance;
  final String accountName;
  final String bankName;
  final String iban;
  final String phoneNumber;

  SendEmailBalanceParams(
      {required this.fullName,
      required this.email,
      required this.balance,
      required this.accountName,
      required this.bankName,
      required this.iban,
      required this.phoneNumber});
}
