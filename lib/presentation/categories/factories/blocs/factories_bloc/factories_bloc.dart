import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/categories/entities/factories/factories.dart';
import 'package:netzoon/domain/categories/usecases/factories/get_all_factories_use_case.dart';
import 'package:netzoon/domain/categories/usecases/factories/get_factory_companies_use_case.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'factories_event.dart';
part 'factories_state.dart';

class FactoriesBloc extends Bloc<FactoriesEvent, FactoriesState> {
  final GetAllFactoriesUseCase getAllFactoriesUseCase;
  final GetFactoryCompaniesUseCase getFactoryCompaniesUseCase;
  final GetCountryUseCase getCountryUseCase;
  FactoriesBloc({
    required this.getAllFactoriesUseCase,
    required this.getFactoryCompaniesUseCase,
    required this.getCountryUseCase,
  }) : super(FactoriesInitial()) {
    on<GetAllFactoriesEvent>((event, emit) async {
      emit(FactoriesInProgress());
      final failureOrFactories = await getAllFactoriesUseCase(NoParams());

      emit(
        failureOrFactories.fold(
          (failure) => FactoriesFailure(message: mapFailureToString(failure)),
          (factories) => FactoriesSuccess(factories: factories),
        ),
      );
    });
    on<GetFactoryCompaniesEvent>((event, emit) async {
      emit(FactoriesInProgress());
      late String country;
      final countryresult = await getCountryUseCase(NoParams());
      countryresult.fold((l) => null, (r) => country = r ?? 'AE');
      final failureOrCompanies = await getFactoryCompaniesUseCase(
          FactoriesCompaniesParams(id: event.id, country: country));

      emit(
        failureOrCompanies.fold((failure) {
          return FactoriesFailure(
            message: mapFailureToString(failure),
          );
        }, (companies) {
          return FactoryCompaniesSuccess(companies: companies.factories);
        }),
      );
    });
  }
}
