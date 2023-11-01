import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/aramex/entities/total_amount.dart';

part 'total_amount_model.g.dart';

@JsonSerializable(createToJson: true)
class TotalAmountModel {
  @JsonKey(name: 'CurrencyCode')
  final String currencyCode;
  @JsonKey(name: 'Value')
  final double value;

  TotalAmountModel({required this.currencyCode, required this.value});

  factory TotalAmountModel.fromJson(Map<String, dynamic> json) =>
      _$TotalAmountModelFromJson(json);

  Map<String, dynamic> toJson() => _$TotalAmountModelToJson(this);
}

extension MapToDomain on TotalAmountModel {
  TotalAmount toDomain() =>
      TotalAmount(currencyCode: currencyCode, value: value);
}
