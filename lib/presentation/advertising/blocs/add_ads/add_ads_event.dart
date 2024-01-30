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
  final File? image;
  final String advertisingYear;
  final String advertisingLocation;
  final double advertisingPrice;
  final String advertisingType;
  final List<XFile>? advertisingImageList;
  final File? video;
  final bool purchasable;
  final String? type;
  final String? category;
  final String? color;
  final bool? guarantee;
  final String? contactNumber;
  final String? imagePath;
  final String? itemId;
  final bool? forPurchase;
  const AddAdsRequestedEvent({
    required this.advertisingTitle,
    required this.advertisingStartDate,
    required this.advertisingEndDate,
    required this.advertisingDescription,
    this.image,
    required this.advertisingYear,
    required this.advertisingLocation,
    required this.advertisingPrice,
    required this.advertisingType,
    this.advertisingImageList,
    this.video,
    required this.purchasable,
    this.type,
    this.category,
    this.color,
    this.guarantee,
    this.contactNumber,
    this.imagePath,
    this.itemId,
    this.forPurchase,
  });
}
