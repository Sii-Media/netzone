import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/entities/local_company/local_company.dart';
import 'package:netzoon/domain/categories/usecases/local_company/get_all_local_companies_use_case.dart';
import 'package:netzoon/domain/categories/usecases/local_company/get_company_products_use_case.dart';
import 'package:netzoon/domain/categories/usecases/local_company/get_local_companies_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/entities/user_info.dart';
import '../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';
import '../../../../domain/departments/usecases/get_user_products_use_case.dart';

part 'local_company_event.dart';
part 'local_company_state.dart';

class LocalCompanyBloc extends Bloc<LocalCompanyEvent, LocalCompanyState> {
  final GetAllLocalCompaniesUseCase getAllLocalCompaniesUseCase;
  final GetCompanyProductsUseCase getCompanyProductsUseCase;
  final GetLocalCompaniesUseCase getLocalCompaniesUseCase;
  final GetSignedInUserUseCase getSignedInUser;
  final GetUserProductsUseCase getUserProductsUseCase;

  LocalCompanyBloc({
    required this.getLocalCompaniesUseCase,
    required this.getAllLocalCompaniesUseCase,
    required this.getCompanyProductsUseCase,
    required this.getSignedInUser,
    required this.getUserProductsUseCase,
  }) : super(LocalCompanyInitial()) {
    on<GetAllLocalCompaniesEvent>((event, emit) async {
      emit(LocalCompanyInProgress());

      final failureOrCompanies = await getAllLocalCompaniesUseCase(NoParams());
      emit(
        failureOrCompanies.fold(
          (failure) =>
              LocalCompanyFailure(message: mapFailureToString(failure)),
          (localCompanies) =>
              LocalCompanySuccess(localCompanies: localCompanies),
        ),
      );
    });
    on<GetLocalCompanyProductsEvent>((event, emit) async {
      emit(LocalCompanyInProgress());
      final failureOrProducts = await getCompanyProductsUseCase(event.id);
      emit(
        failureOrProducts.fold(
          (failure) =>
              LocalCompanyFailure(message: mapFailureToString(failure)),
          (categoryProducts) {
            return LocalCompanyProductsSuccess(products: categoryProducts);
          },
        ),
      );
    });
    on<GetLocalCompaniesEvent>((event, emit) async {
      emit(LocalCompanyInProgress());

      final companies = await getLocalCompaniesUseCase(event.userType);
      final result = await getSignedInUser.call(NoParams());
      late User? user;
      result.fold((l) => null, (r) => user = r);
      // ignore: unused_local_variable
      late List<UserInfo> filteredCompanies;
      filteredCompanies = companies.fold(
        (failure) => [],
        (companies) => companies
            .where((company) => company.username != user?.userInfo.username)
            .toList(),
      );
      // emit(
      //   filteredCompanies.isEmpty
      //       ? const LocalCompanyFailure(message: 'No Companies Founded')
      //       : GetLocalCompaniesSuccess(companies: filteredCompanies),
      // );

      emit(
        companies.fold(
          (failure) =>
              LocalCompanyFailure(message: mapFailureToString(failure)),
          (companies) => GetLocalCompaniesSuccess(companies: companies),
        ),
      );
    });
    on<GetLocalProductsEvent>((event, emit) async {
      emit(LocalCompanyInProgress());
      final products = await getUserProductsUseCase(event.username);
      emit(
        products.fold(
          (failure) =>
              LocalCompanyFailure(message: mapFailureToString(failure)),
          (categoryProducts) =>
              LocalCompanyProductsSuccess(products: categoryProducts),
        ),
      );
    });
  }
}
