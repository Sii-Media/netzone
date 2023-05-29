// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freezone_company_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreeZoneCompanyResponseModel _$FreeZoneCompanyResponseModelFromJson(
        Map<String, dynamic> json) =>
    FreeZoneCompanyResponseModel(
      message: json['message'] as String,
      results:
          FreezoneResultModel.fromJson(json['results'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FreeZoneCompanyResponseModelToJson(
        FreeZoneCompanyResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.results,
    };
