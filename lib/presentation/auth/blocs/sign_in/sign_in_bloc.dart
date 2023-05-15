import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/usecases/sign_in_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase signInUseCase;
  SignInBloc({required this.signInUseCase}) : super(SignInInitial()) {
    on<SignInRequestEvent>(
      (event, emit) async {
        emit(SignInInProgress());
        final failureOrUser = await signInUseCase(
          SignInParams(
            email: event.email,
            password: event.password,
          ),
        );
        emit(
          failureOrUser.fold(
            (failure) {
              return SignInFailure(message: mapFailureToString(failure));
            },
            (user) {
              return SignInSuccess(user: user);
            },
          ),
        );
      },
    );
  }
}
