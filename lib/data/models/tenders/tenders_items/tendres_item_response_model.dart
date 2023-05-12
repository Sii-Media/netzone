import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/tenders/tenders_items/tenders_item_model.dart';
import 'package:netzoon/domain/tenders/entities/tendersItems/tenders_items_response.dart';
part 'tendres_item_response_model.g.dart';

@JsonSerializable()
class TendersItemResponseModel {
  final String message;

  @JsonKey(name: 'results')
  final List<TendersItemModel> tendersItems;

  TendersItemResponseModel({required this.message, required this.tendersItems});

  factory TendersItemResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TendersItemResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TendersItemResponseModelToJson(this);
}

extension MapToDomain on TendersItemResponseModel {
  TenderItemResponse toDomain() => TenderItemResponse(
        message: message,
        tenderItems: tendersItems.map((e) => e.toDomain()).toList(),
      );
}
