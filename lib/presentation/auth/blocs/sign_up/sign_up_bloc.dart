import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/usecases/sign_up_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase signUpUseCase;
  SignUpBloc({required this.signUpUseCase}) : super(SignUpInitial()) {
    on<SignUpEvent>((event, emit) async {
      if (event is SignUpRequested) {
        emit(SignUpInProgress());
        final failureOrUser = await signUpUseCase(SignUpUseCaseParams(
          username: event.username,
          email: event.email,
          password: event.password,
          userType: event.userType,
          firstMobile: event.firstMobile,
          isFreeZoon: event.isFreeZoon,
        ));

        emit(failureOrUser.fold(
            (failure) => (SignUpFailure(message: mapFailureToString(failure))),
            (user) => (SignUpSuccess(user: user))));
      }
    });
  }
}
