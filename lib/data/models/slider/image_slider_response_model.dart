import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/slider/entities/images_slider_response.dart';

part 'image_slider_response_model.g.dart';

@JsonSerializable()
class ImageSliderResponseModel {
  @JsonKey(name: '_id')
  final String id;
  final List<String>? mainSlider;
  final List<String>? secondSlider;

  ImageSliderResponseModel(
      {required this.id, required this.mainSlider, required this.secondSlider});

  factory ImageSliderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ImageSliderResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageSliderResponseModelToJson(this);
}

extension MapToDomain on ImageSliderResponseModel {
  ImagesSliderResponse toDomain() => ImagesSliderResponse(
      id: id, mainSlider: mainSlider, secondSlider: secondSlider);
}
