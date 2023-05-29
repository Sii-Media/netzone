// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freezone_company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreeZoneCompanyModel _$FreeZoneCompanyModelFromJson(
        Map<String, dynamic> json) =>
    FreeZoneCompanyModel(
      id: json['_id'] as String?,
      categoryName: json['categoryName'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      imgurl: json['imgurl'] as String,
      phone: json['phone'] as String?,
      mobile: json['mobile'] as String?,
      companies: (json['companies'] as List<dynamic>?)
          ?.map((e) => CompaniesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      info: json['info'] as String,
      companyimages: (json['companyimages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      videourl: json['videourl'] as String?,
      link: json['link'] as String?,
    );

Map<String, dynamic> _$FreeZoneCompanyModelToJson(
        FreeZoneCompanyModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'categoryName': instance.categoryName,
      'name': instance.name,
      'city': instance.city,
      'address': instance.address,
      'email': instance.email,
      'imgurl': instance.imgurl,
      'phone': instance.phone,
      'mobile': instance.mobile,
      'companies': instance.companies,
      'info': instance.info,
      'companyimages': instance.companyimages,
      'videourl': instance.videourl,
      'link': instance.link,
    };
