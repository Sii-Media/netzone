import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/entities/factories/factories.dart';
import 'package:netzoon/domain/categories/entities/factories/factory_companies.dart';
import 'package:netzoon/domain/categories/usecases/factories/get_all_factories_use_case.dart';
import 'package:netzoon/domain/categories/usecases/factories/get_factory_companies_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'factories_event.dart';
part 'factories_state.dart';

class FactoriesBloc extends Bloc<FactoriesEvent, FactoriesState> {
  final GetAllFactoriesUseCase getAllFactoriesUseCase;
  final GetFactoryCompaniesUseCase getFactoryCompaniesUseCase;
  FactoriesBloc({
    required this.getAllFactoriesUseCase,
    required this.getFactoryCompaniesUseCase,
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
      final failureOrCompanies = await getFactoryCompaniesUseCase(event.id);

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
