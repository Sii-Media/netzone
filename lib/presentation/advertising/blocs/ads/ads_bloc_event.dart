part of 'ads_bloc_bloc.dart';

abstract class AdsBlocEvent extends Equatable {
  const AdsBlocEvent();

  @override
  List<Object> get props => [];
}

class GetAllAdsEvent extends AdsBlocEvent {
  final String? owner;
  final int? priceMin;
  final int? priceMax;
  final bool? purchasable;
  final String? year;

  const GetAllAdsEvent(
      {this.owner, this.priceMin, this.priceMax, this.purchasable, this.year});
}

class GetAdsByType extends AdsBlocEvent {
  final String userAdvertisingType;

  const GetAdsByType({required this.userAdvertisingType});
}

class GetAdsByIdEvent extends AdsBlocEvent {
  final String id;

  const GetAdsByIdEvent({required this.id});
}

class GetUserAdsEvent extends AdsBlocEvent {
  final String userId;

  const GetUserAdsEvent({required this.userId});
}

class EditAdsEvent extends AdsBlocEvent {
  final String id;
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

  const EditAdsEvent(
      {required this.id,
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
      this.contactNumber});
}

class DeleteAdsEvent extends AdsBlocEvent {
  final String id;

  const DeleteAdsEvent({required this.id});
}

class AddAdsVisitorEvent extends AdsBlocEvent {
  final String adsId;

  const AddAdsVisitorEvent({required this.adsId});
}
