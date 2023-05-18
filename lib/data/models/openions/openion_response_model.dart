import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/openions/openion_model.dart';
import 'package:netzoon/domain/openions/entities/openion_response.dart';

part 'openion_response_model.g.dart';

@JsonSerializable()
class OpenionResponseModel {
  final String message;

  @JsonKey(name: 'results')
  final OpenionModel openionModel;

  OpenionResponseModel({required this.message, required this.openionModel});

  factory OpenionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OpenionResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenionResponseModelToJson(this);
}

extension MapToDomain on OpenionResponseModel {
  OpenionResponse toDomain() => OpenionResponse(
        message: message,
        openions: openionModel.toDomain(),
      );
}
