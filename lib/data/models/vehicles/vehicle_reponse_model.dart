import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/vehicles/vehicle_model.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle_response.dart';

part 'vehicle_reponse_model.g.dart';

@JsonSerializable()
class VehicleResponseModel {
  final String message;

  @JsonKey(name: 'results')
  final List<VehicleModel> vehicles;

  VehicleResponseModel({required this.message, required this.vehicles});

  factory VehicleResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleResponseModelToJson(this);
}

extension MapToDomain on VehicleResponseModel {
  VehicleResponse toDomain() => VehicleResponse(
        message: message,
        vehicle: vehicles.map((e) => e.toDomain()).toList(),
      );
}
