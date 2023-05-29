import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/freezone/freezone_company/freezone_results_model.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_places_by_id/freezone_company_response.dart';

part 'freezone_company_response_model.g.dart';

@JsonSerializable()
class FreeZoneCompanyResponseModel {
  final String message;
  @JsonKey(name: 'results')
  final FreezoneResultModel results;

  FreeZoneCompanyResponseModel({required this.message, required this.results});

  factory FreeZoneCompanyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FreeZoneCompanyResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreeZoneCompanyResponseModelToJson(this);
}

extension MapToDomain on FreeZoneCompanyResponseModel {
  FreeZoneCompanyResponse toDomain() => FreeZoneCompanyResponse(
        message: message,
        results: results.toDomain(),
      );
}
