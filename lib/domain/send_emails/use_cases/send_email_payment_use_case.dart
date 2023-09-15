import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../repositories/send_email_repository.dart';

class SendEmailPaymentUseCase extends UseCase<String, SendEmailPaymentParams> {
  final SendEmailRepository sendEmailRepository;

  SendEmailPaymentUseCase({required this.sendEmailRepository});

  @override
  Future<Either<Failure, String>> call(SendEmailPaymentParams params) {
    return sendEmailRepository.sendEmailOnPayment(
        toName: params.toName,
        toEmail: params.toEmail,
        userMobile: params.userMobile,
        productsNames: params.productsNames,
        grandTotal: params.grandTotal,
        serviceFee: params.serviceFee);
  }
}

class SendEmailPaymentParams {
  final String toName;
  final String toEmail;
  final String userMobile;
  final String productsNames;
  final String grandTotal;
  final String serviceFee;

  SendEmailPaymentParams({
    required this.toName,
    required this.toEmail,
    required this.userMobile,
    required this.productsNames,
    required this.grandTotal,
    required this.serviceFee,
  });
}
