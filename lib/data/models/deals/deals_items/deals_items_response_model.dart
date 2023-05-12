import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/deals/deals_items/deals_item_model.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items_response.dart';

part 'deals_items_response_model.g.dart';

@JsonSerializable()
class DealsItemsResponseModel {
  final String message;

  @JsonKey(name: 'results')
  final List<DealsItemsModel> dealsItems;

  DealsItemsResponseModel({
    required this.message,
    required this.dealsItems,
  });

  factory DealsItemsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DealsItemsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DealsItemsResponseModelToJson(this);
}

extension MapToDomain on DealsItemsResponseModel {
  DealsItemsResponse toDomain() => DealsItemsResponse(
        message: message,
        dealsItems: dealsItems.map((e) => e.toDomain()).toList(),
      );
}
