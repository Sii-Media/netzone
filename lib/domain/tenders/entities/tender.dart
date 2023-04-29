import 'package:equatable/equatable.dart';

class Tender extends Equatable {
  final String name;
  final String imgUrl;
  final String companyName;
  final String startDate;
  final String endDate;

  const Tender({
    required this.name,
    required this.imgUrl,
    required this.companyName,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [name, imgUrl, companyName, startDate, endDate];
}
