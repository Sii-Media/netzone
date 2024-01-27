import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';

class Advertisement extends Equatable {
  final UserInfo owner;
  final String id;
  final String name;
  final String advertisingStartDate;
  final String advertisingEndDate;
  final String advertisingDescription;
  final String advertisingImage;

  final int? advertisingViews;
  final String advertisingYear;
  final String advertisingLocation;
  final String advertisingPrice;
  final List<String>? advertisingImageList;
  final String? advertisingVedio;
  final String advertisingType;
  final bool purchasable;
  final String? type;
  final String? category;
  final String? color;
  final bool? guarantee;
  final String? contactNumber;
  final int? adsViews;
  final String? productId;
  final bool? forPurchase;
  const Advertisement({
    required this.owner,
    required this.id,
    required this.name,
    required this.advertisingStartDate,
    required this.advertisingEndDate,
    required this.advertisingDescription,
    required this.advertisingImage,
    required this.advertisingViews,
    required this.advertisingYear,
    required this.advertisingLocation,
    required this.advertisingPrice,
    this.advertisingImageList,
    this.advertisingVedio,
    required this.advertisingType,
    required this.purchasable,
    this.type,
    this.category,
    this.color,
    this.guarantee,
    this.contactNumber,
    this.adsViews,
    this.productId,
    this.forPurchase,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        advertisingStartDate,
        advertisingEndDate,
        advertisingDescription,
        advertisingImage,
        advertisingImageList,
        advertisingVedio,
        advertisingType,
        owner,
        purchasable,
        type,
        category,
        color,
        guarantee,
        contactNumber,
        adsViews,
        productId,
        forPurchase,
      ];
}
