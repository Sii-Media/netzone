import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/label_info_model.dart';

class LabelInfo extends Equatable {
  final int reportID;
  final String reportType;

  const LabelInfo({required this.reportID, required this.reportType});

  @override
  List<Object?> get props => [reportID, reportType];
}

extension MapToDomain on LabelInfo {
  LabelInfoModel fromDomain() =>
      LabelInfoModel(reportID: reportID, reportType: reportType);
}
