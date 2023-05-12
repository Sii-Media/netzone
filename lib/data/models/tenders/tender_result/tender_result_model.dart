import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/tenders/entities/tender_result.dart';

part 'tender_result_model.g.dart';

@JsonSerializable()
class TenderResultModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final List<String> tendersItems;

  TenderResultModel({
    this.id,
    required this.name,
    required this.tendersItems,
  });

  factory TenderResultModel.fromJson(Map<String, dynamic> json) =>
      _$TenderResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$TenderResultModelToJson(this);
}

extension MapToDomain on TenderResultModel {
  TenderResult toDomain() => TenderResult(
        name: name,
        tendersItems: tendersItems,
      );
}
