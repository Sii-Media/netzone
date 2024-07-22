// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_slider_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageSliderResponseModel _$ImageSliderResponseModelFromJson(
        Map<String, dynamic> json) =>
    ImageSliderResponseModel(
      id: json['_id'] as String,
      mainSlider: (json['mainSlider'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      secondSlider: (json['secondSlider'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ImageSliderResponseModelToJson(
        ImageSliderResponseModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'mainSlider': instance.mainSlider,
      'secondSlider': instance.secondSlider,
    };
