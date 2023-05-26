import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/entities/otp_login_response.dart';
import 'package:netzoon/domain/auth/usecases/get_otpcode_use_case.dart';
import 'package:netzoon/domain/auth/usecases/verify_otp_code_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'get_otp_code_event.dart';
part 'get_otp_code_state.dart';

class GetOtpCodeBloc extends Bloc<GetOtpCodeEvent, GetOtpCodeState> {
  final GetOtpCodeUseCase getOtpCodeUseCase;
  final VerifyOtpCodeUseCase verifyOtpCodeUseCase;

  GetOtpCodeBloc(
      {required this.verifyOtpCodeUseCase, required this.getOtpCodeUseCase})
      : super(GetOtpCodeInitial()) {
    on<GetOtpCodeRequestedEvent>((event, emit) async {
      emit(GetOtpCodeInProgress());

      final failureOrSuccess =
          await getOtpCodeUseCase(GetOtpCodeParams(mobileNumber: event.phone));

      emit(
        failureOrSuccess.fold(
          (failure) => GetOtpCodeFailure(mapFailureToString(failure)),
          (response) {
            return GetOtpCodeSuccess(response: response);
          },
        ),
      );
    });
    on<VerifyOtpCodeEvent>(
      (event, emit) async {
        emit(GetOtpCodeInProgress());

        final failureOrSuccess = await verifyOtpCodeUseCase(VerifyOtpCodeParams(
            phone: event.phone, otp: event.otp, hash: event.hash));

        emit(
          failureOrSuccess.fold(
            (failure) => GetOtpCodeFailure(mapFailureToString(failure)),
            (response) {
              return GetOtpCodeSuccess(response: response);
            },
          ),
        );
      },
    );
  }
}
