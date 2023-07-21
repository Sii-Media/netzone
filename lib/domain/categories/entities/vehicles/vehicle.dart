import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';

class Vehicle extends Equatable {
  final String name;
  final String imageUrl;
  final String description;
  final int price;
  final int kilometers;
  final String year;
  final String location;
  final String type;
  final String category;
  final UserInfo? creator;
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

  const Vehicle({
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
  @override
  List<Object?> get props => [
        name,
        imageUrl,
        description,
        price,
        kilometers,
        year,
        location,
        type,
        category,
        creator,
        country,
        contactNumber,
        exteriorColor,
        interiorColor,
        doors,
        bodyCondition,
        bodyType,
        mechanicalCondition,
        seatingCapacity,
        numofCylinders,
        transmissionType,
        horsepower,
        fuelType,
        extras,
        technicalFeatures,
        steeringSide,
        guarantee,
      ];
}
