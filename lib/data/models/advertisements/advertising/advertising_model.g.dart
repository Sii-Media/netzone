// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advertising_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvertisingModel _$AdvertisingModelFromJson(Map<String, dynamic> json) =>
    AdvertisingModel(
      message: json['message'] as String,
      advertisemenetModel: (json['results'] as List<dynamic>)
          .map((e) => AdvertisemenetModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdvertisingModelToJson(AdvertisingModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.advertisemenetModel,
    };
