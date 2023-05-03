import 'package:equatable/equatable.dart';

class Tender extends Equatable {
  final String name;
  final String imgUrl;
  final String companyName;
  final String startDate;
  final String endDate;
  final String tenderValue;
  final String startPrice;

  const Tender({
    required this.name,
    required this.imgUrl,
    required this.companyName,
    required this.startDate,
    required this.endDate,
    required this.tenderValue,
    required this.startPrice,
  });

  @override
  List<Object?> get props => [name, imgUrl, companyName, startDate, endDate];
}
