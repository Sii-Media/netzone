part of 'vehicle_bloc.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleInProgress extends VehicleState {}

class VehicleSuccess extends VehicleState {
  final List<Vehicle> vehilces;

  const VehicleSuccess({required this.vehilces});
}

class VehicleFailure extends VehicleState {
  final String message;

  const VehicleFailure({required this.message});
}

class VehiclesCompaniesSuccess extends VehicleState {
  final List<VehiclesCompanies> vehiclesCompanies;

  const VehiclesCompaniesSuccess({required this.vehiclesCompanies});
}

class GetCompanyVehiclesSuccess extends VehicleState {
  final List<Vehicle> companyVehicles;

  const GetCompanyVehiclesSuccess({required this.companyVehicles});
}
