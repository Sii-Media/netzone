part of 'vehicle_bloc.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object> get props => [];
}

class GetAllCarsEvent extends VehicleEvent {}

class GetAllUsedPlanesEvent extends VehicleEvent {}

class GetAllNewPlanesEvent extends VehicleEvent {}
