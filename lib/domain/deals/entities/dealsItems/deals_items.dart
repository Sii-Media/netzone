import 'package:equatable/equatable.dart';

class DealsItems extends Equatable {
  final String? id;
  final String name;
  final String imgUrl;
  final String companyName;
  final int prevPrice;
  final int currentPrice;
  final String startDate;
  final String endDate;
  final String location;
  final String category;
  final String country;

  const DealsItems({
    this.id,
    required this.name,
    required this.imgUrl,
    required this.companyName,
    required this.prevPrice,
    required this.currentPrice,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    required this.country,
  });
  @override
  List<Object?> get props => [
        id,
        name,
        imgUrl,
        companyName,
        prevPrice,
        currentPrice,
        startDate,
        endDate,
        location,
        category,
        country,
      ];
}
