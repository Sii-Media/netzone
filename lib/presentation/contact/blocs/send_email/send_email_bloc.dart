import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/send_emails/use_cases/send_email_balance_use_case.dart';
import 'package:netzoon/domain/send_emails/use_cases/send_email_delivery_use_case.dart';
import 'package:netzoon/domain/send_emails/use_cases/send_email_payment_use_case.dart';
import 'package:netzoon/domain/send_emails/use_cases/send_email_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'send_email_event.dart';
part 'send_email_state.dart';

class SendEmailBloc extends Bloc<SendEmailEvent, SendEmailState> {
  final SendEmailUseCase sendEmailUseCase;
  final SendEmailPaymentUseCase sendEmailPaymentUseCase;
  final SendEmailDeliveryUseCas sendEmailDeliveryUseCas;
  final SendEmailBalanceUseCase sendEmailBalanceUseCase;
  SendEmailBloc({
    required this.sendEmailUseCase,
    required this.sendEmailPaymentUseCase,
    required this.sendEmailDeliveryUseCas,
    required this.sendEmailBalanceUseCase,
  }) : super(SendEmailInitial()) {
    on<SendEmailRequestEvent>((event, emit) async {
      emit(SendEmailInProgress());

      final response = await sendEmailUseCase(SendEmailParams(
          name: event.name,
          email: event.email,
          subject: event.subject,
          message: event.message));

      emit(
        response.fold(
          (failure) => SendEmailFailure(message: mapFailureToString(failure)),
          (response) => SendEmailSuccess(response: response),
        ),
      );
    });
    on<SendEmailPaymentRequestEvent>((event, emit) async {
      emit(SendEmailInProgress());

      final response = await sendEmailPaymentUseCase(SendEmailPaymentParams(
          toName: event.toName,
          toEmail: event.toEmail,
          userMobile: event.userMobile,
          productsNames: event.productsNames,
          grandTotal: event.grandTotal,
          serviceFee: event.serviceFee));

      emit(
        response.fold(
          (failure) => SendEmailFailure(message: mapFailureToString(failure)),
          (response) => SendEmailPaymentSuccess(
            response: response,
            grandTotal: double.parse(event.grandTotal),
            subtotal: event.subTotal,
            serviceFee: double.parse(event.serviceFee),
          ),
        ),
      );
    });
    on<SendEmailDeliveryRequestEvent>((event, emit) async {
      emit(SendEmailInProgress());

      final response = await sendEmailDeliveryUseCas(SendEmailDeliveryParams(
        toName: event.toName,
        toEmail: event.toEmail,
        mobile: event.mobile,
        city: event.city,
        addressDetails: event.addressDetails,
        floorNum: event.floorNum,
        subject: event.subject,
        from: event.from,
      ));

      emit(
        response.fold(
          (failure) => SendEmailFailure(message: mapFailureToString(failure)),
          (response) => SendEmailDeliverySuccess(response: response),
        ),
      );
    });
    on<SendEmailPaymentAndDeliveryEvent>((event, emit) async {
      emit(SendEmailPaymentAndDeliveryInProgress());

      final result1 = await sendEmailPaymentUseCase(SendEmailPaymentParams(
          toName: event.toName,
          toEmail: event.toEmail,
          userMobile: event.mobile,
          productsNames: event.productsNames,
          grandTotal: event.grandTotal,
          serviceFee: event.serviceFee));

      final result2 = await sendEmailDeliveryUseCas(SendEmailDeliveryParams(
        toName: event.toName,
        toEmail: event.toEmail,
        mobile: event.mobile,
        city: event.city,
        addressDetails: event.addressDetails,
        floorNum: event.floorNum,
        subject: event.subject,
        from: event.from,
      ));

      emit(result2.fold((l) => SendEmailPaymentAndDeliveryFailure(),
          (r) => SendEmailPaymentAndDeliverySuccess()));

      // result1.fold((l) => emit(SendEmailPaymentAndDeliveryFailure()),
      //     (r) async {
      //   final result2 = await sendEmailDeliveryUseCas(SendEmailDeliveryParams(
      //     toName: event.toName,
      //     toEmail: event.toEmail,
      //     mobile: event.mobile,
      //     city: event.city,
      //     addressDetails: event.addressDetails,
      //     floorNum: event.floorNum,
      //     subject: event.subject,
      //     from: event.from,
      //   ));
      //   result2.fold((l) => emit(SendEmailPaymentAndDeliveryFailure()), (r) {
      //     emit(SendEmailPaymentAndDeliverySuccess());
      //   });
      // });
    });
    on<SendEmailBalanceEvent>((event, emit) async {
      emit(SendEmailInProgress());

      final response = await sendEmailBalanceUseCase(SendEmailBalanceParams(
          fullName: event.fullName,
          email: event.email,
          balance: event.balance,
          accountName: event.accountName,
          bankName: event.bankName,
          iban: event.iban,
          phoneNumber: event.phoneNumber));

      emit(
        response.fold(
          (failure) => SendEmailFailure(message: mapFailureToString(failure)),
          (response) => SendEmailSuccess(response: response),
        ),
      );
    });
  }
}
