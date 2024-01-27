// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advertiement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvertisemenetModel _$AdvertisemenetModelFromJson(Map<String, dynamic> json) =>
    AdvertisemenetModel(
      id: json['_id'] as String,
      owner: UserInfoModel.fromJson(json['owner'] as Map<String, dynamic>),
      advertisingTitle: json['advertisingTitle'] as String,
      advertisingStartDate: json['advertisingStartDate'] as String,
      advertisingEndDate: json['advertisingEndDate'] as String,
      advertisingDescription: json['advertisingDescription'] as String,
      advertisingImage: json['advertisingImage'] as String,
      advertisingViews: json['advertisingViews'] as int?,
      advertisingYear: json['advertisingYear'] as String,
      advertisingLocation: json['advertisingLocation'] as String,
      advertisingPrice: json['advertisingPrice'] as int,
      advertisingImageList: (json['advertisingImageList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      advertisingVedio: json['advertisingVedio'] as String?,
      advertisingType: json['advertisingType'] as String,
      purchasable: json['purchasable'] as bool,
      type: json['type'] as String?,
      category: json['category'] as String?,
      color: json['color'] as String?,
      guarantee: json['guarantee'] as bool?,
      contactNumber: json['contactNumber'] as String?,
      adsViews: json['adsViews'] as int?,
      productId: json['productId'] as String?,
      forPurchase: json['forPurchase'] as bool?,
    );

Map<String, dynamic> _$AdvertisemenetModelToJson(
        AdvertisemenetModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'owner': instance.owner,
      'advertisingTitle': instance.advertisingTitle,
      'advertisingStartDate': instance.advertisingStartDate,
      'advertisingEndDate': instance.advertisingEndDate,
      'advertisingDescription': instance.advertisingDescription,
      'advertisingImage': instance.advertisingImage,
      'advertisingViews': instance.advertisingViews,
      'advertisingYear': instance.advertisingYear,
      'advertisingLocation': instance.advertisingLocation,
      'advertisingPrice': instance.advertisingPrice,
      'advertisingImageList': instance.advertisingImageList,
      'advertisingVedio': instance.advertisingVedio,
      'advertisingType': instance.advertisingType,
      'purchasable': instance.purchasable,
      'type': instance.type,
      'category': instance.category,
      'color': instance.color,
      'guarantee': instance.guarantee,
      'contactNumber': instance.contactNumber,
      'adsViews': instance.adsViews,
      'productId': instance.productId,
      'forPurchase': instance.forPurchase,
    };
