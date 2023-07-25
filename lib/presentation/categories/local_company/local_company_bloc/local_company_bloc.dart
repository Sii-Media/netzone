import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/entities/local_company/local_company.dart';
import 'package:netzoon/domain/categories/usecases/local_company/add_company_service_use_case.dart';
import 'package:netzoon/domain/categories/usecases/local_company/get_all_local_companies_use_case.dart';
import 'package:netzoon/domain/categories/usecases/local_company/get_company_products_use_case.dart';
import 'package:netzoon/domain/categories/usecases/local_company/get_local_companies_use_case.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/entities/user_info.dart';
import '../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';
import '../../../../domain/categories/usecases/local_company/get_company_service_use_case.dart';
import '../../../../domain/company_service/company_service.dart';
import '../../../../domain/departments/usecases/get_user_products_use_case.dart';

part 'local_company_event.dart';
part 'local_company_state.dart';

class LocalCompanyBloc extends Bloc<LocalCompanyEvent, LocalCompanyState> {
  final GetAllLocalCompaniesUseCase getAllLocalCompaniesUseCase;
  final GetCompanyProductsUseCase getCompanyProductsUseCase;
  final GetLocalCompaniesUseCase getLocalCompaniesUseCase;
  final GetSignedInUserUseCase getSignedInUser;
  final GetUserProductsUseCase getUserProductsUseCase;
  final GetCountryUseCase getCountryUseCase;
  final AddCompanyServiceUseCase addCompanyServiceUseCase;
  final GetCompanyServicesUseCase getCompanyServicesUseCase;
  LocalCompanyBloc({
    required this.getLocalCompaniesUseCase,
    required this.getAllLocalCompaniesUseCase,
    required this.getCompanyProductsUseCase,
    required this.getSignedInUser,
    required this.getUserProductsUseCase,
    required this.getCountryUseCase,
    required this.addCompanyServiceUseCase,
    required this.getCompanyServicesUseCase,
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
      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');
      final companies = await getLocalCompaniesUseCase(
          GetLocalCompaniesParams(country: country, userType: event.userType));
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
          (companies) {
            filteredCompanies = companies
                .where((company) => company.username != user?.userInfo.username)
                .toList();
            return GetLocalCompaniesSuccess(companies: filteredCompanies);
          },
        ),
      );

      // emit(
      //   companies.fold(
      //     (failure) =>
      //         LocalCompanyFailure(message: mapFailureToString(failure)),
      //     (companies) => GetLocalCompaniesSuccess(companies: companies),
      //   ),
      // );
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
    on<AddCompanyServiceEvent>((event, emit) async {
      emit(LocalCompanyInProgress());

      final result = await getSignedInUser.call(NoParams());
      late User? user;
      result.fold((l) => null, (r) => user = r);
      final success = await addCompanyServiceUseCase(AddCompanyServiceParams(
          title: event.title,
          description: event.description,
          price: event.price,
          owner: user?.userInfo.id ?? ''));
      emit(
        success.fold(
          (failure) =>
              LocalCompanyFailure(message: mapFailureToString(failure)),
          (message) => AddCompanyServiceSuccess(message: message),
        ),
      );
    });
    on<GetCompanyServicesEvent>((event, emit) async {
      emit(LocalCompanyInProgress());
      final result = await getSignedInUser.call(NoParams());
      late User? user;
      result.fold((l) => null, (r) => user = r);
      final services = await getCompanyServicesUseCase(user?.userInfo.id ?? '');
      emit(
        services.fold(
          (failure) =>
              LocalCompanyFailure(message: mapFailureToString(failure)),
          (services) => GetCompanyServiceSuccess(services: services),
        ),
      );
    });
    on<GetCompanyServicesByIdEvent>((event, emit) async {
      emit(LocalCompanyInProgress());

      final services = await getCompanyServicesUseCase(event.id);
      emit(
        services.fold(
          (failure) =>
              LocalCompanyFailure(message: mapFailureToString(failure)),
          (services) => GetCompanyServiceSuccess(services: services),
        ),
      );
    });
  }
}
