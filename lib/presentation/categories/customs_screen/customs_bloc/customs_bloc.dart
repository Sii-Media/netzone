import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/entities/customs/customs.dart';
import 'package:netzoon/domain/categories/entities/customs/customs_company.dart';
import 'package:netzoon/domain/categories/usecases/customs/get_all_customs_use_case.dart';
import 'package:netzoon/domain/categories/usecases/customs/get_custom_companies_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'customs_event.dart';
part 'customs_state.dart';

class CustomsBloc extends Bloc<CustomsEvent, CustomsState> {
  final GetAllCustomsUseCase getAllCustomsUseCase;
  final GetCustomCompaniesUseCase getCustomCompaniesUseCase;
  CustomsBloc(
      {required this.getAllCustomsUseCase,
      required this.getCustomCompaniesUseCase})
      : super(CustomsInitial()) {
    on<GetAllCustomsEvent>((event, emit) async {
      emit(CustomsInProgress());
      final failureOrCustoms = await getAllCustomsUseCase(NoParams());

      emit(
        failureOrCustoms.fold(
          (failure) => CustomsFailure(message: mapFailureToString(failure)),
          (customs) => CustomsSuccess(customs: customs),
        ),
      );
    });
    on<GetCustomsCompaniesEvent>((event, emit) async {
      emit(CustomsInProgress());
      final failureOrCompanies = await getCustomCompaniesUseCase(event.id);

      emit(
        failureOrCompanies.fold(
          (failure) => CustomsFailure(message: mapFailureToString(failure)),
          (companies) => CustomsCompaniesSuccess(companies: companies),
        ),
      );
    });
  }
}
