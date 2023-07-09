part of 'vehicle_bloc.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object> get props => [];
}

class GetAllCarsEvent extends VehicleEvent {}

class GetLatestCarByCreatorEvent extends VehicleEvent {}

class GetAllPlanesEvent extends VehicleEvent {}

class GetAllUsedPlanesEvent extends VehicleEvent {}

class GetAllNewPlanesEvent extends VehicleEvent {}

class GetCarsCompaniesEvent extends VehicleEvent {}

class GetPlanesCompaniesEvent extends VehicleEvent {}

class GetCompanyVehiclesEvent extends VehicleEvent {
  final String type;
  final String id;

  const GetCompanyVehiclesEvent({required this.type, required this.id});
}
