// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyServiceModel _$CompanyServiceModelFromJson(Map<String, dynamic> json) =>
    CompanyServiceModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      owner: UserInfoModel.fromJson(json['owner'] as Map<String, dynamic>),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$CompanyServiceModelToJson(
        CompanyServiceModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'owner': instance.owner,
      'imageUrl': instance.imageUrl,
    };
