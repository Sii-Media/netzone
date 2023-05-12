// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tendres_item_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TendersItemResponseModel _$TendersItemResponseModelFromJson(
        Map<String, dynamic> json) =>
    TendersItemResponseModel(
      message: json['message'] as String,
      tendersItems: (json['results'] as List<dynamic>)
          .map((e) => TendersItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TendersItemResponseModelToJson(
        TendersItemResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.tendersItems,
    };
