import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_places_by_id/freezone_result.dart';
import 'package:netzoon/domain/categories/usecases/freezone/get_freezone_places_by_id_use_case.dart';
import 'package:netzoon/domain/categories/usecases/freezone/get_freezone_places_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'freezone_event.dart';
part 'freezone_state.dart';

class FreezoneBloc extends Bloc<FreezoneEvent, FreezoneState> {
  final GetFreeZonePlacesUseCase getFreeZonePlacesUseCase;
  final GetFreeZonePlacesByIdUseCase getFreeZonePlacesByIdUseCase;
  FreezoneBloc(
      {required this.getFreeZonePlacesUseCase,
      required this.getFreeZonePlacesByIdUseCase})
      : super(FreezoneInitial()) {
    on<GetFreeZonePlacesEvent>((event, emit) async {
      emit(FreezoneInProgress());

      final failureOrFreezone = await getFreeZonePlacesUseCase(NoParams());
      emit(
        failureOrFreezone.fold(
          (failure) => FreezoneFailure(message: mapFailureToString(failure)),
          (freezones) {
            return FreezoneSuccess(freezones: freezones.results);
          },
        ),
      );
    });
    on<GetFreeZonePlacesByIdEvent>((event, emit) async {
      emit(FreezoneInProgress());
      final failureOrcompanies = await getFreeZonePlacesByIdUseCase(
          GetFreeZonePlacesByIdParams(id: event.id));
      emit(
        failureOrcompanies.fold(
          (failure) => FreezoneFailure(message: mapFailureToString(failure)),
          (freezonescompanies) => FreezoneByIdSuccess(
              freezonescompanies: freezonescompanies.results),
        ),
      );
    });
  }
}
