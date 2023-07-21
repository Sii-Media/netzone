import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_user_by_id_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_user_followers_use_case.dart';
import 'package:netzoon/domain/auth/usecases/get_user_followings_use_case.dart';
import 'package:netzoon/domain/auth/usecases/toggle_follow_use_case.dart';
import 'package:netzoon/domain/departments/usecases/add_to_selected_products_use_case.dart';
import 'package:netzoon/domain/departments/usecases/delete_from_selected_products_use_case.dart';
import 'package:netzoon/domain/departments/usecases/get_selected_products_use_case.dart';
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
  final GetSelectedProductsUseCase getSelectedProductsUseCase;
  final AddToSelectedProductsUseCase addToSelectedProductsUseCase;
  final DeleteFromSelectedProductsUseCase deleteFromSelectedProductsUseCase;
  final GetUserFollowingsUseCase getUserFollowingsUseCase;
  final GetUserFollowersUseCase getUserFollowersUseCase;
  final ToggleFollowUseCase toggleFollowUseCase;
  GetUserBloc({
    required this.getUserByIdUseCase,
    required this.getUserProductsUseCase,
    required this.getSignedInUserUseCase,
    required this.getSelectedProductsUseCase,
    required this.addToSelectedProductsUseCase,
    required this.deleteFromSelectedProductsUseCase,
    required this.getUserFollowingsUseCase,
    required this.getUserFollowersUseCase,
    required this.toggleFollowUseCase,
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

      final products = await getUserProductsUseCase(user.userInfo.id);

      emit(
        products.fold(
          (failure) =>
              GetUserProductsFailure(message: mapFailureToString(failure)),
          (products) => GetUserProductsSuccess(products: products),
        ),
      );
    });
    on<GetUserProductsByIdEvent>((event, emit) async {
      emit(GetUserProductsInProgress());

      final products = await getUserProductsUseCase(event.id);

      emit(
        products.fold(
          (failure) =>
              GetUserProductsFailure(message: mapFailureToString(failure)),
          (products) => GetUserProductsSuccess(products: products),
        ),
      );
    });
    on<GetSelectedProductsEvent>((event, emit) async {
      emit(GetSelectedProductsInProgress());

      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      final products = await getSelectedProductsUseCase(user.userInfo.id);

      emit(
        products.fold(
          (failure) =>
              GetSelectedProductsFailure(message: mapFailureToString(failure)),
          (products) => GetSelectedProductsSuccess(products: products),
        ),
      );
    });
    on<AddToSelectedProductsEvent>((event, emit) async {
      emit(AddToSelectedProductsInProgress());
      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);

      final products = await addToSelectedProductsUseCase(
          AddToSelectedProductsParams(
              userId: user.userInfo.id, productIds: event.productIds));
      emit(
        products.fold(
          (failure) => AddToSelectedProductsFailure(
              message: mapFailureToString(failure)),
          (message) => AddToSelectedProductsSuccess(message: message),
        ),
      );
    });
    on<DeleteFromSelectedProductsEvent>((event, emit) async {
      emit(DeleteFromSelectedProductsInProgress());

      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);

      final products = await deleteFromSelectedProductsUseCase(
          DeleteFromSelectedProductsParams(
              userId: user.userInfo.id, productId: event.productId));

      emit(
        products.fold(
          (failure) => DeleteFromSelectedProductsFailure(
              message: mapFailureToString(failure)),
          (message) => DeleteFromSelectedProductsSuccess(message: message),
        ),
      );
    });
    on<GetSelectedProductsByUserIdEvent>((event, emit) async {
      emit(GetSelectedProductsInProgress());

      final products = await getSelectedProductsUseCase(event.userId);

      emit(
        products.fold(
          (failure) =>
              GetSelectedProductsFailure(message: mapFailureToString(failure)),
          (products) => GetSelectedProductsSuccess(products: products),
        ),
      );
    });
    on<GetUserFollowingsEvent>((event, emit) async {
      emit(GetUserFollowsInProgress());

      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);

      final followings = await getUserFollowingsUseCase(user.userInfo.id);

      emit(
        followings.fold(
          (failure) =>
              GetUserFollowsFailure(message: mapFailureToString(failure)),
          (followings) => GetUserFollowsSuccess(follows: followings),
        ),
      );
    });
    on<GetUserFollowersEvent>((event, emit) async {
      emit(GetUserFollowsInProgress());

      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);

      final followings = await getUserFollowersUseCase(user.userInfo.id);

      emit(
        followings.fold(
          (failure) =>
              GetUserFollowsFailure(message: mapFailureToString(failure)),
          (followers) => GetUserFollowsSuccess(follows: followers),
        ),
      );
    });
    on<GetUserFollowingsByIdEvent>((event, emit) async {
      emit(GetUserFollowsInProgress());
      final followings = await getUserFollowingsUseCase(event.id);
      emit(
        followings.fold(
          (failure) =>
              GetUserFollowsFailure(message: mapFailureToString(failure)),
          (followers) => GetUserFollowsSuccess(follows: followers),
        ),
      );
    });
    on<GetUserFollowersByIdEvent>((event, emit) async {
      emit(GetUserFollowsInProgress());
      final followings = await getUserFollowersUseCase(event.id);
      emit(
        followings.fold(
          (failure) =>
              GetUserFollowsFailure(message: mapFailureToString(failure)),
          (followers) => GetUserFollowsSuccess(follows: followers),
        ),
      );
    });
    on<ToggleFollowEvent>((event, emit) async {
      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      await toggleFollowUseCase(ToggleFollowParams(
          currentUserId: user.userInfo.id, otherUserId: event.otherUserId));
    });
  }
}
