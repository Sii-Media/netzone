part of 'vehicle_bloc.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object> get props => [];
}

class GetAllCarsEvent extends VehicleEvent {
  final String? creator;
  final int? priceMin;
  final int? priceMax;
  final String? type;

  const GetAllCarsEvent(
      {this.creator, this.priceMin, this.priceMax, this.type});
}

class GetLatestCarByCreatorEvent extends VehicleEvent {}

class GetAllPlanesEvent extends VehicleEvent {
  final String? creator;
  final int? priceMin;
  final int? priceMax;
  final String? type;

  const GetAllPlanesEvent(
      {this.creator, this.priceMin, this.priceMax, this.type});
}

class GetAllUsedPlanesEvent extends VehicleEvent {}

class GetAllNewPlanesEvent extends VehicleEvent {}

class GetCarsCompaniesEvent extends VehicleEvent {}

class GetPlanesCompaniesEvent extends VehicleEvent {}

class GetSeaCompaniesEvent extends VehicleEvent {}

class GetCompanyVehiclesEvent extends VehicleEvent {
  final String type;
  final String id;

  const GetCompanyVehiclesEvent({required this.type, required this.id});
}

class GetVehicleByIdEvent extends VehicleEvent {
  final String id;

  const GetVehicleByIdEvent({required this.id});
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
  final String? contactNumber;
  final String? exteriorColor;
  final String? interiorColor;
  final int? doors;
  final String? bodyCondition;
  final String? bodyType;
  final String? mechanicalCondition;
  final int? seatingCapacity;
  final int? numofCylinders;
  final String? transmissionType;
  final String? horsepower;
  final String? fuelType;
  final String? extras;
  final String? technicalFeatures;
  final String? steeringSide;
  final bool? guarantee;
  final String? forWhat;
  final String? regionalSpecs;

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
    this.contactNumber,
    this.exteriorColor,
    this.interiorColor,
    this.doors,
    this.bodyCondition,
    this.bodyType,
    this.mechanicalCondition,
    this.seatingCapacity,
    this.numofCylinders,
    this.transmissionType,
    this.horsepower,
    this.fuelType,
    this.extras,
    this.technicalFeatures,
    this.steeringSide,
    this.guarantee,
    this.forWhat,
    this.regionalSpecs,
  });
}
