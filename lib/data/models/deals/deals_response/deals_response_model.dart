import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/deals/deals_result/deals_result_model.dart';
import 'package:netzoon/domain/deals/entities/deals/deals_response.dart';

part 'deals_response_model.g.dart';

@JsonSerializable()
class DealsResponseModel {
  final String message;
  @JsonKey(name: 'results')
  final List<DealsResultModel> dealsResult;

  DealsResponseModel({
    required this.message,
    required this.dealsResult,
  });

  factory DealsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DealsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DealsResponseModelToJson(this);
}

extension MapToDomain on DealsResponseModel {
  DealsResponse toDomain() => DealsResponse(
        message: message,
        dealsCat: dealsResult.map((e) => e.toDomain()).toList(),
      );
}
