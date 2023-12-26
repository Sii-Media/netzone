import 'package:equatable/equatable.dart';

import '../../../auth/entities/user_info.dart';

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
  final UserInfo owner;
  final String? description;
  const DealsItems({
    this.id,
    required this.owner,
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
    this.description,
  });
  @override
  List<Object?> get props => [
        id,
        owner,
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
        description,
      ];
}
