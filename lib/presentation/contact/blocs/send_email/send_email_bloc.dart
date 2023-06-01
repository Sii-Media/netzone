import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/send_emails/use_cases/send_email_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'send_email_event.dart';
part 'send_email_state.dart';

class SendEmailBloc extends Bloc<SendEmailEvent, SendEmailState> {
  final SendEmailUseCase sendEmailUseCase;
  SendEmailBloc({required this.sendEmailUseCase}) : super(SendEmailInitial()) {
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
  }
}
