import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental_companies.dart';
import 'package:netzoon/domain/categories/usecases/governmental/get_all_governmental_use_case.dart';
import 'package:netzoon/domain/categories/usecases/governmental/get_govermental_companies_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'govermental_event.dart';
part 'govermental_state.dart';

class GovermentalBloc extends Bloc<GovermentalEvent, GovermentalState> {
  final GetAllGovermentalUseCase getAllGovermentalUseCase;
  final GetGovermentalCompaniesUseCase getGovermentalCompaniesUseCase;
  GovermentalBloc(
      {required this.getAllGovermentalUseCase,
      required this.getGovermentalCompaniesUseCase})
      : super(GovermentalInitial()) {
    on<GetAllGovermentalsEvent>((event, emit) async {
      emit(GovermentalInProgress());

      final failureOrGovermental = await getAllGovermentalUseCase(NoParams());

      emit(failureOrGovermental.fold(
        (failure) => GovermentalFailure(message: mapFailureToString(failure)),
        (govermentals) => GovermentalSuccess(govermentals: govermentals),
      ));
    });
    on<GetGovermentalCompaniesEvent>((event, emit) async {
      emit(GovermentalInProgress());

      final failureOrCompanies = await getGovermentalCompaniesUseCase(event.id);

      emit(failureOrCompanies.fold(
        (failure) => GovermentalFailure(message: mapFailureToString(failure)),
        (companies) => GovermentalCompaniesSuccess(companies: companies),
      ));
    });
  }
}
