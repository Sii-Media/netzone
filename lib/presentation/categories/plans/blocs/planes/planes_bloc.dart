import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_new_planes_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_used_planes_use_case.dart';

part 'planes_event.dart';
part 'planes_state.dart';

class PlanesBloc extends Bloc<PlanesEvent, PlanesState> {
  final GetAllUsedPlanesUseCase getAllUsedPlanesUseCase;
  final GetAllNewPlanesUseCase getAllNewPlanesUseCase;
  PlanesBloc(
      {required this.getAllUsedPlanesUseCase,
      required this.getAllNewPlanesUseCase})
      : super(PlanesInitial()) {
    // on<GetAllUsedPlanesEvent>((event, emit) async {
    //   emit(PlanesInProgress());

    //   final failureOrPlanes = await getAllUsedPlanesUseCase(NoParams());

    //   emit(
    //     failureOrPlanes.fold(
    //       (failure) => PlanesFailure(message: mapFailureToString(failure)),
    //       (planes) => PlanesSuccess(planes: planes.vehicle),
    //     ),
    //   );
    // });
    // on<GetAllNewPlanesEvent>((event, emit) async {
    //   emit(PlanesInProgress());

    //   final failureOrPlanes = await getAllNewPlanesUseCase(NoParams());

    //   emit(
    //     failureOrPlanes.fold(
    //       (failure) => PlanesFailure(message: mapFailureToString(failure)),
    //       (planes) => PlanesSuccess(planes: planes.vehicle),
    //     ),
    //   );
    // });
  }
}
