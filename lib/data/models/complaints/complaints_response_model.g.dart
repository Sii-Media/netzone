// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaints_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplaintsResponseModel _$ComplaintsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ComplaintsResponseModel(
      message: json['message'] as String,
      complaintsModel: (json['results'] as List<dynamic>)
          .map((e) => ComplaintsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ComplaintsResponseModelToJson(
        ComplaintsResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.complaintsModel,
    };
