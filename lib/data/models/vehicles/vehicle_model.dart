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
      );
}
