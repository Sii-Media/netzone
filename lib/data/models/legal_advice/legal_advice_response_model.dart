import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/legal_advice/legal_advice_model.dart';
import 'package:netzoon/domain/legal_advice/entities/legal_advice_response.dart';

part 'legal_advice_response_model.g.dart';

@JsonSerializable()
class LegalAdviceResponseModel {
  final String message;

  @JsonKey(name: 'results')
  final List<LegalAdviceModel> legalAdiceModel;

  LegalAdviceResponseModel(
      {required this.message, required this.legalAdiceModel});

  factory LegalAdviceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LegalAdviceResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LegalAdviceResponseModelToJson(this);
}

extension MapToDomain on LegalAdviceResponseModel {
  LegalAdviceResponse toDomain() => LegalAdviceResponse(
        message: message,
        legalAdvices: legalAdiceModel.map((e) => e.toDomain()).toList(),
      );
}
