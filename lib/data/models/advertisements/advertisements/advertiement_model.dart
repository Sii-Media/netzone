import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';

part 'advertiement_model.g.dart';

@JsonSerializable()
class AdvertisemenetModel {
  @JsonKey(name: '_id')
  final String id;
  final String advertisingTitle;
  final String advertisingStartDate;
  final String advertisingEndDate;
  final String advertisingDescription;
  final String advertisingImage;
  final String advertisingCountryAlphaCode;
  final String advertisingBrand;
  final int advertisingViews;
  final String advertisingYear;
  final String advertisingLocation;
  final int advertisingPrice;
  final List<String>? advertisingImageList;
  final String? advertisingVedio;

  AdvertisemenetModel({
    required this.id,
    required this.advertisingTitle,
    required this.advertisingStartDate,
    required this.advertisingEndDate,
    required this.advertisingDescription,
    required this.advertisingImage,
    required this.advertisingCountryAlphaCode,
    required this.advertisingBrand,
    required this.advertisingViews,
    required this.advertisingYear,
    required this.advertisingLocation,
    required this.advertisingPrice,
    this.advertisingImageList,
    this.advertisingVedio,
  });

  factory AdvertisemenetModel.fromJson(Map<String, dynamic> json) =>
      _$AdvertisemenetModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdvertisemenetModelToJson(this);
}

extension MapToDomain on AdvertisemenetModel {
  Advertisement toDomain() => Advertisement(
        advertisingTitle: advertisingTitle,
        advertisingStartDate: advertisingStartDate,
        advertisingEndDate: advertisingEndDate,
        advertisingDescription: advertisingDescription,
        advertisingImage: advertisingImage,
        advertisingCountryAlphaCode: advertisingCountryAlphaCode,
        advertisingBrand: advertisingBrand,
        advertisingViews: advertisingViews.toString(),
        advertisingYear: advertisingYear,
        advertisingLocation: advertisingLocation,
        advertisingPrice: advertisingPrice.toString(),
        advertisingImageList: advertisingImageList,
        advertisingVedio: advertisingVedio,
      );
}
