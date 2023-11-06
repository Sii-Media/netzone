import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class SendEmailRepository {
  Future<Either<Failure, String>> sendEmail({
    required final String name,
    required final String email,
    required final String subject,
    required final String message,
  });
  Future<Either<Failure, String>> sendEmailOnPayment(
      {required String toName,
      required String toEmail,
      required String userMobile,
      required String productsNames,
      required String grandTotal,
      required String serviceFee});
  Future<Either<Failure, String>> sendEmailOnDelivery({
    required final String toName,
    required final String toEmail,
    required final String mobile,
    required final String city,
    required final String addressDetails,
    required final String floorNum,
    required final String subject,
    required String from,
  });
  Future<Either<Failure, String>> sendEmailBalance({
    required String fullName,
    required String email,
    required double balance,
    required String accountName,
    required String bankName,
    required String iban,
    required String phoneNumber,
  });
}
