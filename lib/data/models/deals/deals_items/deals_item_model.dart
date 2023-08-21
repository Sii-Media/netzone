import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items.dart';

part 'deals_item_model.g.dart';

@JsonSerializable()
class DealsItemsModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String imgUrl;
  final String companyName;
  final int prevPrice;
  final int currentPrice;
  final String startDate;
  final String endDate;
  final String location;
  final String category;
  final String country;
  final UserInfoModel owner;
  DealsItemsModel({
    this.id,
    required this.name,
    required this.imgUrl,
    required this.companyName,
    required this.prevPrice,
    required this.currentPrice,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    required this.country,
    required this.owner,
  });

  factory DealsItemsModel.fromJson(Map<String, dynamic> json) =>
      _$DealsItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DealsItemsModelToJson(this);
}

extension MapToDomain on DealsItemsModel {
  DealsItems toDomain() => DealsItems(
        id: id,
        owner: owner.toDomain(),
        name: name,
        imgUrl: imgUrl,
        companyName: companyName,
        prevPrice: prevPrice,
        currentPrice: currentPrice,
        startDate: startDate,
        endDate: endDate,
        location: location,
        category: category,
        country: country,
      );
}
