import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String imageUrl;
  final String description;
  final int price;
  final int kilometers;
  final String year;
  final String location;
  final String type;
  final String category;
  final UserInfoModel? creator;
  final List<String>? carImages;
  final String? vedioUrl;
  final String country;
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

  VehicleModel({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.kilometers,
    required this.year,
    required this.location,
    required this.type,
    required this.category,
    this.creator,
    this.carImages,
    this.vedioUrl,
    required this.country,
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
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
}

extension MapToDomain on VehicleModel {
  Vehicle toDomain() => Vehicle(
        name: name,
        imageUrl: imageUrl,
        description: description,
        price: price,
        kilometers: kilometers,
        year: year,
        location: location,
        type: type,
        category: category,
        creator: creator?.toDomain(),
        carImages: carImages,
        vedioUrl: vedioUrl,
        country: country,
        contactNumber: contactNumber,
        exteriorColor: exteriorColor,
        interiorColor: interiorColor,
        bodyCondition: bodyCondition,
        bodyType: bodyType,
        doors: doors,
        extras: extras,
        fuelType: fuelType,
        horsepower: horsepower,
        mechanicalCondition: mechanicalCondition,
        numofCylinders: numofCylinders,
        seatingCapacity: seatingCapacity,
        steeringSide: steeringSide,
        technicalFeatures: technicalFeatures,
        transmissionType: transmissionType,
        guarantee: guarantee,
      );
}
