part of 'add_ads_bloc.dart';

abstract class AddAdsEvent extends Equatable {
  const AddAdsEvent();

  @override
  List<Object> get props => [];
}

class AddAdsRequestedEvent extends AddAdsEvent {
  final String advertisingTitle;
  final String advertisingStartDate;
  final String advertisingEndDate;
  final String advertisingDescription;
  final File image;
  final String advertisingCountryAlphaCode;
  final String advertisingBrand;
  final String advertisingYear;
  final String advertisingLocation;
  final double advertisingPrice;
  final String advertisingType;
  final List<XFile>? advertisingImageList;
  final File? video;
  final bool purchasable;

  const AddAdsRequestedEvent({
    required this.advertisingTitle,
    required this.advertisingStartDate,
    required this.advertisingEndDate,
    required this.advertisingDescription,
    required this.image,
    required this.advertisingCountryAlphaCode,
    required this.advertisingBrand,
    required this.advertisingYear,
    required this.advertisingLocation,
    required this.advertisingPrice,
    required this.advertisingType,
    this.advertisingImageList,
    this.video,
    required this.purchasable,
  });
}
