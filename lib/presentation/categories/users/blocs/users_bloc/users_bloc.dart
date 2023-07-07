import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/usecases/users/get_users_list_use_case.dart';

import '../../../../../domain/auth/entities/user.dart';
import '../../../../../domain/auth/entities/user_info.dart';
import '../../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';
import '../../../../../domain/core/usecase/usecase.dart';
import '../../../../core/helpers/map_failure_to_string.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetSignedInUserUseCase getSignedInUser;
  final GetUsersListUseCase getUsersListUseCase;
  UsersBloc({required this.getSignedInUser, required this.getUsersListUseCase})
      : super(UsersInitial()) {
    on<GetUsersListEvent>((event, emit) async {
      emit(GetUsersInProgress());

      final users = await getUsersListUseCase(event.userType);
      final result = await getSignedInUser.call(NoParams());
      late User? user;
      result.fold((l) => null, (r) => user = r);
      late List<UserInfo> filteredUsers;
      filteredUsers = users.fold(
        (failure) => [],
        (usersList) => usersList
            .where(
                (singleUser) => singleUser.username != user?.userInfo.username)
            .toList(),
      );
      emit(
        users.fold(
          (failure) => GetUsersFailure(message: mapFailureToString(failure)),
          (usersList) => GetUsersSuccess(users: usersList),
        ),
      );
    });
  }
}
