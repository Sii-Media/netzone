import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/aramex/entities/actual_weight.dart';
part 'actual_weight_model.g.dart';

@JsonSerializable(createToJson: true)
class ActualWeightModel {
  @JsonKey(name: 'Unit')
  final String unit;
  @JsonKey(name: 'Value')
  final double value;

  ActualWeightModel({required this.unit, required this.value});

  factory ActualWeightModel.fromJson(Map<String, dynamic> json) =>
      _$ActualWeightModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActualWeightModelToJson(this);
}

extension MapToDomain on ActualWeightModel {
  ActualWeight toDomain() => ActualWeight(unit: unit, value: value);
}
