// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalCompanyModel _$LocalCompanyModelFromJson(Map<String, dynamic> json) =>
    LocalCompanyModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      imgUrl: json['imgUrl'] as String,
      description: json['description'] as String,
      desc2: json['desc2'] as String,
      mobile: json['mobile'] as String,
      mail: json['mail'] as String,
      website: json['website'] as String,
      docs: (json['docs'] as List<dynamic>).map((e) => e as String).toList(),
      coverUrl: json['coverUrl'] as String?,
    );

Map<String, dynamic> _$LocalCompanyModelToJson(LocalCompanyModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'imgUrl': instance.imgUrl,
      'description': instance.description,
      'desc2': instance.desc2,
      'mobile': instance.mobile,
      'mail': instance.mail,
      'website': instance.website,
      'docs': instance.docs,
      'coverUrl': instance.coverUrl,
    };
