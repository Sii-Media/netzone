import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/fees/entities/fees_resposne.dart';

part 'fees_response_model.g.dart';

@JsonSerializable()
class FeesResponseModel {
  final double? feesFromSeller;
  final double? feesFromBuyer;
  final double? adsFees;
  final double? dealsFees;

  FeesResponseModel(
      {required this.feesFromSeller,
      required this.feesFromBuyer,
      required this.adsFees,
      required this.dealsFees});

  factory FeesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FeesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeesResponseModelToJson(this);
}

extension MapToDomain on FeesResponseModel {
  FeesResponse toDomain() => FeesResponse(
      feesFromSeller: feesFromSeller,
      feesFromBuyer: feesFromBuyer,
      adsFees: adsFees,
      dealsFees: dealsFees);
}
