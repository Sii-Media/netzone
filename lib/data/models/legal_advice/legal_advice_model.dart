import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/legal_advice/entities/legal_advice.dart';

part 'legal_advice_model.g.dart';

@JsonSerializable()
class LegalAdviceModel {
  @JsonKey(name: '_id')
  final String? id;
  final String text;
  final String textEn;
  final String termofUse;
  final String termofUseEn;

  LegalAdviceModel({
    this.id,
    required this.text,
    required this.textEn,
    required this.termofUse,
    required this.termofUseEn,
  });

  factory LegalAdviceModel.fromJson(Map<String, dynamic> json) =>
      _$LegalAdviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$LegalAdviceModelToJson(this);
}

extension MapToDomain on LegalAdviceModel {
  LegalAdvice toDomain() => LegalAdvice(
      text: text,
      textEn: textEn,
      termofUse: termofUse,
      termofUseEn: termofUseEn);
}
