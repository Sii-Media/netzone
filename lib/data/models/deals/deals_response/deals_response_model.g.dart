// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deals_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DealsResponseModel _$DealsResponseModelFromJson(Map<String, dynamic> json) =>
    DealsResponseModel(
      message: json['message'] as String,
      dealsResult: (json['results'] as List<dynamic>)
          .map((e) => DealsResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DealsResponseModelToJson(DealsResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.dealsResult,
    };
