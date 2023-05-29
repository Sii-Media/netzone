part of 'planes_bloc.dart';

abstract class PlanesState extends Equatable {
  const PlanesState();

  @override
  List<Object> get props => [];
}

class PlanesInitial extends PlanesState {}

class PlanesInProgress extends PlanesState {}

class PlanesSuccess extends PlanesState {
  final List<Vehicle> planes;

  const PlanesSuccess({required this.planes});
}

class PlanesFailure extends PlanesState {
  final String message;

  const PlanesFailure({required this.message});
}
