import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/usecases/users/get_users_list_use_case.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';

import '../../../../../domain/auth/entities/user.dart';
import '../../../../../domain/auth/entities/user_info.dart';
import '../../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';
import '../../../../../domain/core/usecase/usecase.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  List<UserInfo> filteredUsers = [];
  final GetSignedInUserUseCase getSignedInUser;
  final GetUsersListUseCase getUsersListUseCase;
  final GetCountryUseCase getCountryUseCase;
  UsersBloc(
      {required this.getSignedInUser,
      required this.getUsersListUseCase,
      required this.getCountryUseCase})
      : super(UsersInitial()) {
    on<GetUsersListEvent>((event, emit) async {
      emit(GetUsersInProgress());
      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');
      final users = await getUsersListUseCase(GetUsersListParams(
        country: country,
        userType: event.userType,
      ));
      final result = await getSignedInUser.call(NoParams());
      late User? user;
      result.fold((l) => null, (r) => user = r);
      // ignore: unused_local_variable
      // late List<UserInfo> filteredUsers;

      filteredUsers = users.fold(
        (failure) => [],
        (usersList) => usersList
            .where(
                (singleUser) => singleUser.username != user?.userInfo.username)
            .toList(),
      );
      // emit(
      //   users.fold(
      //     (failure) => GetUsersFailure(message: mapFailureToString(failure)),
      //     (usersList) => GetUsersSuccess(users: usersList),
      //   ),
      // );
      emit(GetUsersSuccess(users: filteredUsers));
    });
    on<SearchUsersEvent>((event, emit) {
      final searchResults = filteredUsers
          .where((user) => user.freezoneCity!
              .toLowerCase()
              .contains(event.searchQuery.toLowerCase()))
          .toList();
      emit(GetUsersSuccess(users: searchResults));
    });
  }
}
