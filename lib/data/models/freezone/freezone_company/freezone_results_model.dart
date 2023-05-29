import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/freezone/freezone_company/freezone_company_model.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_places_by_id/freezone_result.dart';

part 'freezone_results_model.g.dart';

@JsonSerializable()
class FreezoneResultModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String imageUrl;
  final List<FreeZoneCompanyModel> freezoonplaces;

  FreezoneResultModel(
      {this.id,
      required this.name,
      required this.imageUrl,
      required this.freezoonplaces});

  factory FreezoneResultModel.fromJson(Map<String, dynamic> json) =>
      _$FreezoneResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreezoneResultModelToJson(this);
}

extension MapToDomain on FreezoneResultModel {
  FreezoneResult toDomain() => FreezoneResult(
        name: name,
        imageUrl: imageUrl,
        freezoonplaces: freezoonplaces.map((e) => e.toDomain()).toList(),
      );
}
