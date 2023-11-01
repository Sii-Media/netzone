// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelInfoModel _$LabelInfoModelFromJson(Map<String, dynamic> json) =>
    LabelInfoModel(
      reportID: json['ReportID'] as int,
      reportType: json['ReportType'] as String,
    );

Map<String, dynamic> _$LabelInfoModelToJson(LabelInfoModel instance) =>
    <String, dynamic>{
      'ReportID': instance.reportID,
      'ReportType': instance.reportType,
    };
