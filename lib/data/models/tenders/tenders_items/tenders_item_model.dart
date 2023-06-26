import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/tenders/entities/tendersItems/tender_item.dart';

part 'tenders_item_model.g.dart';

@JsonSerializable()
class TendersItemModel {
  @JsonKey(name: '_id')
  final String? id;
  final String nameAr;
  final String nameEn;
  final String companyName;
  final String startDate;
  final String endDate;
  final int price;
  final String imageUrl;
  final int? value;
  final String category;

  TendersItemModel({
    this.id,
    required this.nameAr,
    required this.nameEn,
    required this.companyName,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.imageUrl,
    this.value,
    required this.category,
  });

  factory TendersItemModel.fromJson(Map<String, dynamic> json) =>
      _$TendersItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$TendersItemModelToJson(this);
}

extension MapToDomain on TendersItemModel {
  TenderItem toDomain() => TenderItem(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        companyName: companyName,
        startDate: startDate,
        endDate: endDate,
        price: price,
        imageUrl: imageUrl,
        value: value,
        category: category,
      );
}
