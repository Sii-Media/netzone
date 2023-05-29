import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle.dart';
import 'package:netzoon/domain/categories/usecases/vehicles/get_all_cars_use_case.dart';

part 'cars_event.dart';
part 'cars_state.dart';

class CarsBloc extends Bloc<CarsEvent, CarsState> {
  final GetAllCarsUseCase getAllCarsUseCase;
  CarsBloc({required this.getAllCarsUseCase}) : super(CarsInitial()) {
    // on<GetAllCarsEvent>((event, emit) async {
    //   emit(CarsInProgress());

    //   final failureOrCars = await getAllCarsUseCase(NoParams());

    //   emit(
    //     failureOrCars.fold(
    //       (failure) => CarsFailure(message: mapFailureToString(failure)),
    //       (cars) => CarsSuccess(cars: cars.vehicle),
    //     ),
    //   );
    // });
  }
}
