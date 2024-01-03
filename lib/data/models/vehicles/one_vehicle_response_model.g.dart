// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_vehicle_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneVehicleResponseModel _$OneVehicleResponseModelFromJson(
        Map<String, dynamic> json) =>
    OneVehicleResponseModel(
      message: json['message'] as String,
      vehicle: VehicleModel.fromJson(json['results'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OneVehicleResponseModelToJson(
        OneVehicleResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.vehicle,
    };
