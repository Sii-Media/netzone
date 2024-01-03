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

class GetVehicleByIdSuccess extends VehicleState {
  final Vehicle vehicle;

  const GetVehicleByIdSuccess({required this.vehicle});
}

class VehiclesCompaniesSuccess extends VehicleState {
  final List<UserInfo> vehiclesCompanies;

  const VehiclesCompaniesSuccess({required this.vehiclesCompanies});
}

class GetCompanyVehiclesSuccess extends VehicleState {
  final List<Vehicle> companyVehicles;

  const GetCompanyVehiclesSuccess({required this.companyVehicles});
}

class AddVehicleInProgress extends VehicleState {}

class AddVehicleFailure extends VehicleState {
  final String message;

  const AddVehicleFailure({required this.message});
}

class AddVehicleSuccess extends VehicleState {
  final String message;

  const AddVehicleSuccess({required this.message});
}
