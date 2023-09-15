import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/send_emails/repositories/send_email_repository.dart';

class SendEmailDeliveryUseCas extends UseCase<String, SendEmailDeliveryParams> {
  final SendEmailRepository sendEmailRepository;

  SendEmailDeliveryUseCas({required this.sendEmailRepository});
  @override
  Future<Either<Failure, String>> call(SendEmailDeliveryParams params) {
    return sendEmailRepository.sendEmailOnDelivery(
      toName: params.toName,
      toEmail: params.toEmail,
      mobile: params.mobile,
      city: params.city,
      addressDetails: params.addressDetails,
      floorNum: params.floorNum,
      subject: params.subject,
      from: params.from,
    );
  }
}

class SendEmailDeliveryParams {
  final String toName;
  final String toEmail;
  final String mobile;
  final String city;
  final String addressDetails;
  final String floorNum;
  final String subject;
  final String from;
  SendEmailDeliveryParams(
      {required this.toName,
      required this.toEmail,
      required this.mobile,
      required this.city,
      required this.addressDetails,
      required this.floorNum,
      required this.subject,
      required this.from});
}
