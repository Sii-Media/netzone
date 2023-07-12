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

class AddVehicleEvent extends VehicleEvent {
  final String name;
  final String description;
  final int price;
  final int kilometers;
  final DateTime year;
  final String location;
  final String type;
  final String category;
  final File image;
  final List<XFile>? carimages;
  final File? video;

  const AddVehicleEvent({
    required this.name,
    required this.description,
    required this.price,
    required this.kilometers,
    required this.year,
    required this.location,
    required this.type,
    required this.category,
    required this.image,
    this.carimages,
    this.video,
  });
}
