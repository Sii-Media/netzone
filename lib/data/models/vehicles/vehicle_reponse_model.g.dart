// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_reponse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleResponseModel _$VehicleResponseModelFromJson(
        Map<String, dynamic> json) =>
    VehicleResponseModel(
      message: json['message'] as String,
      vehicles: (json['results'] as List<dynamic>)
          .map((e) => VehicleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VehicleResponseModelToJson(
        VehicleResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.vehicles,
    };
