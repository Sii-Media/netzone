import 'package:json_annotation/json_annotation.dart';

part 'label_info_model.g.dart';

@JsonSerializable(createToJson: true)
class LabelInfoModel {
  @JsonKey(name: 'ReportID')
  final int reportID;
  @JsonKey(name: 'ReportType')
  final String reportType;

  LabelInfoModel({required this.reportID, required this.reportType});

  factory LabelInfoModel.fromJson(Map<String, dynamic> json) =>
      _$LabelInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$LabelInfoModelToJson(this);
}
