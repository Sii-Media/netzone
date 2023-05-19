// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advertiement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvertisemenetModel _$AdvertisemenetModelFromJson(Map<String, dynamic> json) =>
    AdvertisemenetModel(
      id: json['_id'] as String,
      advertisingTitle: json['advertisingTitle'] as String,
      advertisingStartDate: json['advertisingStartDate'] as String,
      advertisingEndDate: json['advertisingEndDate'] as String,
      advertisingDescription: json['advertisingDescription'] as String,
      advertisingImage: json['advertisingImage'] as String,
      advertisingCountryAlphaCode:
          json['advertisingCountryAlphaCode'] as String,
      advertisingBrand: json['advertisingBrand'] as String,
      advertisingViews: json['advertisingViews'] as int?,
      advertisingYear: json['advertisingYear'] as String,
      advertisingLocation: json['advertisingLocation'] as String,
      advertisingPrice: json['advertisingPrice'] as int,
      advertisingImageList: (json['advertisingImageList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      advertisingVedio: json['advertisingVedio'] as String?,
      advertisingType: json['advertisingType'] as String,
    );

Map<String, dynamic> _$AdvertisemenetModelToJson(
        AdvertisemenetModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'advertisingTitle': instance.advertisingTitle,
      'advertisingStartDate': instance.advertisingStartDate,
      'advertisingEndDate': instance.advertisingEndDate,
      'advertisingDescription': instance.advertisingDescription,
      'advertisingImage': instance.advertisingImage,
      'advertisingCountryAlphaCode': instance.advertisingCountryAlphaCode,
      'advertisingBrand': instance.advertisingBrand,
      'advertisingViews': instance.advertisingViews,
      'advertisingYear': instance.advertisingYear,
      'advertisingLocation': instance.advertisingLocation,
      'advertisingPrice': instance.advertisingPrice,
      'advertisingImageList': instance.advertisingImageList,
      'advertisingVedio': instance.advertisingVedio,
      'advertisingType': instance.advertisingType,
    };
