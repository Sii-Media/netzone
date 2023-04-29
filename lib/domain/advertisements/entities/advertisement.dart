// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Advertisement extends Equatable {
  final String advertisingTitle;
  final String advertisingStartDate;
  final String advertisingEndDate;
  final String advertisingDescription;
  final String advertisingImage;
  final String advertisingCountryAlphaCode;
  const Advertisement({
    required this.advertisingTitle,
    required this.advertisingStartDate,
    required this.advertisingEndDate,
    required this.advertisingDescription,
    required this.advertisingImage,
    required this.advertisingCountryAlphaCode,
  });

  @override
  List<Object?> get props => [
        advertisingTitle,
        advertisingStartDate,
        advertisingEndDate,
        advertisingDescription,
        advertisingImage,
        advertisingCountryAlphaCode,
      ];
}
