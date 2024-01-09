import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/usecases/delete_account_use_case.dart';
import 'package:netzoon/domain/auth/usecases/forget_password_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_first_time_logged_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/auth/usecases/logout_use_case.dart';
import 'package:netzoon/domain/auth/usecases/oAuth_sign_use_case.dart';
import 'package:netzoon/domain/auth/usecases/reset_password_use_case.dart';
import 'package:netzoon/domain/auth/usecases/set_first_time_logged_use_case.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';
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
  final OAuthSignUseCase oauthSignUseCase;
  final GetCountryUseCase getCountryUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  AuthBloc({
    required this.getCountryUseCase,
    required this.getSignedInUser,
    required this.getFirstTimeLogged,
    required this.setFirstTimeLogged,
    required this.logoutUseCase,
    required this.deleteAccountUseCase,
    required this.oauthSignUseCase,
    required this.forgetPasswordUseCase,
    required this.resetPasswordUseCase,
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
          (l) => DeleteAccountFailure(
                message: mapFailureToString(l),
                failure: l,
              ),
          (r) => DeleteAccountSuccess()));
    });
    on<SigninWithFacebookEvent>((event, emit) async {
      emit(SigninWithFacebookInProgress());
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();

        print(userData);
        emit(SigninWithFacebookSuccess(userData: userData));
      } else {
        emit(SigninWithFacebookFailure());
      }
    });
    on<SigninWithGoogleEvent>((event, emit) async {
      emit(SigninWithGoogleInProgress());
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser != null) {
        print(gUser);
        emit(SigninWithGoogleSuccess(
            email: gUser.email,
            username: gUser.displayName ?? 'User',
            profile: gUser.photoUrl ??
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'));
      } else {
        emit(SigninWithGoogleFailure());
      }
    });
    on<OAuthSignEvent>((event, emit) async {
      emit(OAuthSignInProgress());
      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');
      final user = await oauthSignUseCase(OAuthSignParams(
        username: event.username,
        email: event.email,
        country: country,
        profilePhoto: event.profilePhoto,
      ));
      emit(user.fold(
          (l) => OAuthSignFailure(), (r) => OAuthSignSuccess(user: r)));
    });
    on<ForgetPasswordEvent>((event, emit) async {
      emit(ForgetPasswordInProgress());

      final result = await forgetPasswordUseCase(event.email);

      emit(result.fold((l) => ForgetPasswordFailure(),
          (r) => ForgetPasswordSuccess(result: r)));
    });
    on<ResetPasswordEvent>((event, emit) async {
      emit(ResetPasswordInProgress());
      final response = await resetPasswordUseCase(
          ResetPasswordParams(password: event.password, token: event.token));

      emit(response.fold((l) => ResetPasswordFailure(),
          (r) => ResetPasswordSuccess(result: r)));
    });
  }
}
