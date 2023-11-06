part of 'send_email_bloc.dart';

abstract class SendEmailEvent extends Equatable {
  const SendEmailEvent();

  @override
  List<Object> get props => [];
}

class SendEmailRequestEvent extends SendEmailEvent {
  final String name;
  final String email;
  final String subject;
  final String message;

  const SendEmailRequestEvent(
      {required this.name,
      required this.email,
      required this.subject,
      required this.message});
}

class SendEmailPaymentRequestEvent extends SendEmailEvent {
  final String toName;
  final String toEmail;
  final String userMobile;
  final String productsNames;
  final String grandTotal;
  final String serviceFee;
  final double subTotal;

  const SendEmailPaymentRequestEvent({
    required this.toName,
    required this.toEmail,
    required this.userMobile,
    required this.productsNames,
    required this.grandTotal,
    required this.serviceFee,
    required this.subTotal,
  });
}

class SendEmailDeliveryRequestEvent extends SendEmailEvent {
  final String toName;
  final String toEmail;
  final String mobile;
  final String city;
  final String addressDetails;
  final String floorNum;
  final String subject;
  final String from;
  const SendEmailDeliveryRequestEvent({
    required this.toName,
    required this.toEmail,
    required this.mobile,
    required this.city,
    required this.addressDetails,
    required this.floorNum,
    required this.subject,
    required this.from,
  });
}

class SendEmailPaymentAndDeliveryEvent extends SendEmailEvent {
  final String toName;
  final String toEmail;
  final String mobile;
  final String city;
  final String productsNames;
  final String grandTotal;
  final String serviceFee;
  final double subTotal;
  final String addressDetails;
  final String floorNum;
  final String subject;
  final String from;

  const SendEmailPaymentAndDeliveryEvent(
      {required this.toName,
      required this.toEmail,
      required this.mobile,
      required this.city,
      required this.productsNames,
      required this.grandTotal,
      required this.serviceFee,
      required this.subTotal,
      required this.addressDetails,
      required this.floorNum,
      required this.subject,
      required this.from});
}

class SendEmailBalanceEvent extends SendEmailEvent {
  final String fullName;
  final String email;
  final double balance;
  final String accountName;
  final String bankName;
  final String iban;
  final String phoneNumber;

  const SendEmailBalanceEvent(
      {required this.fullName,
      required this.email,
      required this.balance,
      required this.accountName,
      required this.bankName,
      required this.iban,
      required this.phoneNumber});
}
