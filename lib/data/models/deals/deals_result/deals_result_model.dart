import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/deals/entities/deals/deals_result.dart';

part 'deals_result_model.g.dart';

@JsonSerializable()
class DealsResultModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final List<String> dealsItems;

  DealsResultModel({
    this.id,
    required this.name,
    required this.dealsItems,
  });

  factory DealsResultModel.fromJson(Map<String, dynamic> json) =>
      _$DealsResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$DealsResultModelToJson(this);
}

extension MapToDomain on DealsResultModel {
  DealsResult toDomain() => DealsResult(
        name: name,
        dealsItems: dealsItems,
      );
}
