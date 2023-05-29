import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/entities/local_company/local_company.dart';
import 'package:netzoon/domain/categories/usecases/local_company/get_all_local_companies_use_case.dart';
import 'package:netzoon/domain/categories/usecases/local_company/get_company_products_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'local_company_event.dart';
part 'local_company_state.dart';

class LocalCompanyBloc extends Bloc<LocalCompanyEvent, LocalCompanyState> {
  final GetAllLocalCompaniesUseCase getAllLocalCompaniesUseCase;
  final GetCompanyProductsUseCase getCompanyProductsUseCase;
  LocalCompanyBloc({
    required this.getAllLocalCompaniesUseCase,
    required this.getCompanyProductsUseCase,
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
            return LocalCompanyProductsSuccess(
                categoryProducts: categoryProducts);
          },
        ),
      );
    });
  }
}
