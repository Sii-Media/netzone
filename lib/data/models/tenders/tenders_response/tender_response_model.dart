import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/tenders/tender_result/tender_result_model.dart';
import 'package:netzoon/domain/tenders/entities/tender_response.dart';

part 'tender_response_model.g.dart';

@JsonSerializable()
class TenderResponseModel {
  final String message;
  @JsonKey(name: 'results')
  final List<TenderResultModel> tendersResult;

  TenderResponseModel({required this.message, required this.tendersResult});

  factory TenderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TenderResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TenderResponseModelToJson(this);
}

extension MapToDomain on TenderResponseModel {
  TenderResponse toDomain() => TenderResponse(
        message: message,
        tendersCat: tendersResult.map((e) => e.toDomain()).toList(),
      );
}
