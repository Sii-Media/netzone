import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_user_by_id_use_case.dart';
import 'package:netzoon/domain/departments/usecases/get_user_products_use_case.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/entities/user_info.dart';
import '../../../../domain/core/usecase/usecase.dart';
import '../../../../domain/departments/entities/category_products/category_products.dart';
import '../../../core/helpers/map_failure_to_string.dart';

part 'get_user_event.dart';
part 'get_user_state.dart';

class GetUserBloc extends Bloc<GetUserEvent, GetUserState> {
  final GetUserByIdUseCase getUserByIdUseCase;
  final GetUserProductsUseCase getUserProductsUseCase;
  final GetSignedInUserUseCase getSignedInUserUseCase;
  GetUserBloc({
    required this.getUserByIdUseCase,
    required this.getUserProductsUseCase,
    required this.getSignedInUserUseCase,
  }) : super(GetUserInitial()) {
    on<GetUserByIdEvent>((event, emit) async {
      emit(GetUserInProgress());

      final user = await getUserByIdUseCase(event.userId);

      emit(
        user.fold(
          (failure) => GetUserFailure(message: mapFailureToString(failure)),
          (userInfo) => GetUserSuccess(userInfo: userInfo),
        ),
      );
    });
    on<OnEditProfileEvent>((event, emit) async {
      state.props[0] = event.userInfo;
      emit(GetUserSuccess(userInfo: state.props[0]));
    });
    on<GetUserProductsEvent>((event, emit) async {
      emit(GetUserProductsInProgress());

      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);

      final products =
          await getUserProductsUseCase(user.userInfo.username ?? '');

      emit(
        products.fold(
          (failure) =>
              GetUserProductsFailure(message: mapFailureToString(failure)),
          (products) => GetUserProductsSuccess(products: products),
        ),
      );
    });
  }
}
