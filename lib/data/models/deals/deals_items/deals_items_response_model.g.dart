// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deals_items_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DealsItemsResponseModel _$DealsItemsResponseModelFromJson(
        Map<String, dynamic> json) =>
    DealsItemsResponseModel(
      message: json['message'] as String,
      dealsItems: (json['results'] as List<dynamic>)
          .map((e) => DealsItemsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DealsItemsResponseModelToJson(
        DealsItemsResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.dealsItems,
    };
