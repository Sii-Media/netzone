import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/usecases/change_password_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/core/usecase/usecase.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;
  final GetSignedInUserUseCase getSignedInUserUseCase;
  ChangePasswordBloc({
    required this.changePasswordUseCase,
    required this.getSignedInUserUseCase,
  }) : super(ChangePasswordInitial()) {
    on<ChangePasswordRequestedEvent>((event, emit) async {
      emit(ChangePasswordInProgress());
      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);

      final failureOrSuccess = await changePasswordUseCase(
        ChangePasswordParams(
          userId: user.userInfo.id,
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
        ),
      );
      emit(
        failureOrSuccess.fold(
          (failure) => ChangePasswordFailure(
              message: mapFailureToString(failure), failure: failure),
          (result) => ChangePasswordSuccess(result: result),
        ),
      );
    });
  }
}
