import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/freezone/freezone_places/freezone_model.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_response.dart';

part 'freezone_response_model.g.dart';

@JsonSerializable()
class FreeZoneResponseModel {
  final String message;
  @JsonKey(name: 'results')
  final List<FreeZoneModel> freezones;

  FreeZoneResponseModel(this.message, this.freezones);

  factory FreeZoneResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FreeZoneResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreeZoneResponseModelToJson(this);
}

extension MapToDomain on FreeZoneResponseModel {
  FreeZoneResponse toDomain() => FreeZoneResponse(
        message: message,
        results: freezones.map((e) => e.toDomain()).toList(),
      );
}
