part of 'cars_bloc.dart';

abstract class CarsState extends Equatable {
  const CarsState();

  @override
  List<Object> get props => [];
}

class CarsInitial extends CarsState {}

class CarsInProgress extends CarsState {}

class CarsSuccess extends CarsState {
  final List<Vehicle> cars;

  const CarsSuccess({required this.cars});
}

class CarsFailure extends CarsState {
  final String message;

  const CarsFailure({required this.message});
}
