import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/usecases/change_account_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/entities/user_info.dart';
import '../../../../domain/auth/usecases/add_account_to_user_use_case.dart';
import '../../../../domain/auth/usecases/get_user_accounts_use_case.dart';
import '../../../../domain/auth/usecases/logout_use_case.dart';
import '../../../../domain/core/usecase/usecase.dart';

part 'add_account_event.dart';
part 'add_account_state.dart';

class AddAccountBloc extends Bloc<AddAccountEvent, AddAccountState> {
  final AddAccountUseCase addAccountUseCase;
  final GetUserAccountsUseCase getUserAccountsUseCase;
  final GetSignedInUserUseCase getSignedInUserUseCase;
  final ChangeAccountUseCase changeAccountUseCase;
  final LogoutUseCase logoutUseCase;

  AddAccountBloc({
    required this.addAccountUseCase,
    required this.getUserAccountsUseCase,
    required this.getSignedInUserUseCase,
    required this.changeAccountUseCase,
    required this.logoutUseCase,
  }) : super(AddAccountInitial()) {
    on<AddAccountRequestedEvent>((event, emit) async {
      emit(AddAccountInProgress());

      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      final userOrFailure = await addAccountUseCase(AddAccountParams(
        email: user.userInfo.email ?? '',
        username: event.username,
        password: event.password,
      ));

      emit(
        userOrFailure.fold(
          (failure) => AddAccountFailure(message: mapFailureToString(failure)),
          (userInfo) => AddAccountSuccess(userInfo: userInfo),
        ),
      );
    });
    on<GetUserAccountsEvent>((event, emit) async {
      emit(GetUserAccountsInProgress());
      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      final users = await getUserAccountsUseCase(user.userInfo.email ?? '');

      emit(
        users.fold(
          (failure) =>
              GetUserAccountsFailure(message: mapFailureToString(failure)),
          (users) => GetUserAccountsSuccess(users: users),
        ),
      );
    });
    on<OnChangeAccountEvent>((event, emit) async {
      emit(OnChangeAccountInProgress());

      await logoutUseCase(NoParams());

      final failureOrUser = await changeAccountUseCase(
        ChangeAccountParams(
          email: event.email,
          password: event.password,
        ),
      );
      emit(
        failureOrUser.fold(
          (failure) =>
              OnChangeAccountFailure(message: mapFailureToString(failure)),
          (user) => OnChangeAccountSuccess(user: user),
        ),
      );
    });
  }
}
