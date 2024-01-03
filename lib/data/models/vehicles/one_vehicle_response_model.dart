import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/vehicles/vehicle_model.dart';
import 'package:netzoon/domain/categories/entities/vehicles/one_vehicle_response.dart';

part 'one_vehicle_response_model.g.dart';

@JsonSerializable()
class OneVehicleResponseModel {
  final String message;

  @JsonKey(name: 'results')
  final VehicleModel vehicle;

  OneVehicleResponseModel({required this.message, required this.vehicle});

  factory OneVehicleResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OneVehicleResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OneVehicleResponseModelToJson(this);
}

extension MapToDomain on OneVehicleResponseModel {
  OneVehicleResponse toDomain() =>
      OneVehicleResponse(message: message, vehicle: vehicle.toDomain());
}
