import 'package:equatable/equatable.dart';

class TenderItem extends Equatable {
  final String? id;
  final String nameAr;
  final String nameEn;
  final String companyName;
  final String startDate;
  final String endDate;
  final int price;
  final String type;
  final int value;
  final String category;

  const TenderItem({
    this.id,
    required this.nameAr,
    required this.nameEn,
    required this.companyName,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.type,
    required this.value,
    required this.category,
  });
  @override
  List<Object?> get props => [
        id,
        nameAr,
        nameEn,
        companyName,
        startDate,
        endDate,
        price,
        type,
        value,
        category
      ];
}
