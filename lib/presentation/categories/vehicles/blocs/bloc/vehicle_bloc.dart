import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_cars_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_new_planes_use_case.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_used_planes_use_case.dart';

import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetAllCarsUseCase getAllCarsUseCase;
  final GetAllUsedPlanesUseCase getAllUsedPlanesUseCase;
  final GetAllNewPlanesUseCase getAllNewPlanesUseCase;
  VehicleBloc(
      {required this.getAllCarsUseCase,
      required this.getAllUsedPlanesUseCase,
      required this.getAllNewPlanesUseCase})
      : super(VehicleInitial()) {
    on<GetAllCarsEvent>((event, emit) async {
      emit(VehicleInProgress());

      final failureOrCars = await getAllCarsUseCase(NoParams());

      emit(
        failureOrCars.fold(
          (failure) => VehicleFailure(message: mapFailureToString(failure)),
          (cars) => VehicleSuccess(vehilces: cars.vehicle),
        ),
      );
    });
    on<GetAllUsedPlanesEvent>((event, emit) async {
      emit(VehicleInProgress());

      final failureOrPlanes = await getAllUsedPlanesUseCase(NoParams());

      emit(
        failureOrPlanes.fold(
          (failure) => VehicleFailure(message: mapFailureToString(failure)),
          (planes) => VehicleSuccess(vehilces: planes.vehicle),
        ),
      );
    });
    on<GetAllNewPlanesEvent>((event, emit) async {
      emit(VehicleInProgress());

      final failureOrPlanes = await getAllNewPlanesUseCase(NoParams());

      emit(
        failureOrPlanes.fold(
          (failure) => VehicleFailure(message: mapFailureToString(failure)),
          (planes) => VehicleSuccess(vehilces: planes.vehicle),
        ),
      );
    });
  }
}
