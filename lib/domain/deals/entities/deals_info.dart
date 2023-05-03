import 'package:equatable/equatable.dart';

class DealsInfo extends Equatable {
  final String name;
  final String imgUrl;
  final String companyName;
  final String prepeice;
  final String currpeice;
  final String startDate;
  final String endDate;
  final String location;

  const DealsInfo({
    required this.name,
    required this.imgUrl,
    required this.companyName,
    required this.prepeice,
    required this.currpeice,
    required this.startDate,
    required this.endDate,
    required this.location,
  });
  @override
  List<Object?> get props =>
      [name, imgUrl, companyName, prepeice, currpeice, startDate, endDate];
}
