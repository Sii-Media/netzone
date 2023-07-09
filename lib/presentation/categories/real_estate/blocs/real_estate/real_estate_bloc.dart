import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/usecases/real_estate/get_all_real_estates_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../../domain/categories/entities/real_estate/real_estate.dart';

part 'real_estate_event.dart';
part 'real_estate_state.dart';

class RealEstateBloc extends Bloc<RealEstateEvent, RealEstateState> {
  final GetAllRealEstatesUseCase getAllRealEstatesUseCase;
  RealEstateBloc({required this.getAllRealEstatesUseCase})
      : super(RealEstateInitial()) {
    on<GetAllRealEstatesEvent>((event, emit) async {
      emit(GetRealEstateInProgress());

      final realEstates = await getAllRealEstatesUseCase(NoParams());

      emit(
        realEstates.fold(
          (failure) =>
              GetRealEstateFailure(message: mapFailureToString(failure)),
          (realEstates) => GetAllRealEstatesSuccess(realEstates: realEstates),
        ),
      );
    });
  }
}
