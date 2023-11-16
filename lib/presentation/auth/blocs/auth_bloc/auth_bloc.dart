import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/usecases/delete_account_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_first_time_logged_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/auth/usecases/logout_use_case.dart';
import 'package:netzoon/domain/auth/usecases/set_first_time_logged_use_case.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetSignedInUserUseCase getSignedInUser;
  final GetFirstTimeLoggedUseCase getFirstTimeLogged;
  final SetFirstTimeLoggedUseCase setFirstTimeLogged;
  final LogoutUseCase logoutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  AuthBloc({
    required this.getSignedInUser,
    required this.getFirstTimeLogged,
    required this.setFirstTimeLogged,
    required this.logoutUseCase,
    required this.deleteAccountUseCase,
  }) : super(AuthInitial()) {
    on<AuthSetFirstTimeLogged>((event, emit) {
      setFirstTimeLogged(SetFirstTimeLoggedUseCaseParams(
          isFirstTimeLogged: event.isFirstTimeLogged));
    });
    on<AuthCheckRequested>((event, emit) async {
      emit(AuthInProgress());
      final result = await getSignedInUser.call(NoParams());
      final result2 = await getFirstTimeLogged(NoParams());

      emit(
        result.fold(
          (failure) => AuthFailure(failure),
          (user) {
            if (user != null) {
              return Authenticated(user);
            } else {
              return result2.fold(
                  (l) => AuthFailure(l), (r) => Unauthenticated(r!));
            }
          },
        ),
      );
    });
    on<AuthLogin>((event, emit) {
      emit(Authenticated(event.user));
    });
    on<AuthLogout>((event, emit) async {
      await logoutUseCase(NoParams());
      emit(const Unauthenticated(false));
    });
    on<DeleteMyAccountEvent>((event, emit) async {
      emit(DeleteAccountInProgress());
      final result = await getSignedInUser.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      final deleted = await deleteAccountUseCase(user.userInfo.id);
      await logoutUseCase(NoParams());
      emit(deleted.fold(
          (l) => DeleteAccountFailure(message: mapFailureToString(l)),
          (r) => DeleteAccountSuccess()));
    });
  }
}
