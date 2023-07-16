import 'package:equatable/equatable.dart';

import '../../../auth/entities/user_info.dart';
import '../departments_categories/departments_categories.dart';

class CategoryProducts extends Equatable {
  final String id;
  final UserInfo owner;
  final String name;
  final String imageUrl;
  final DepartmentsCategories category;
  final String? condition;
  final String description;
  final int price;
  final List<String>? images;
  final String? vedioUrl;
  final bool? guarantee;
  final String? propert;
  final String? address;
  final String? madeIn;
  final String? year;
  final num? quantity;
  final String? gifUrl;
  final double? discountPercentage;
  final double? priceAfterDiscount;
  final String country;
  const CategoryProducts({
    required this.id,
    required this.owner,
    required this.name,
    required this.imageUrl,
    required this.category,
    this.condition,
    required this.description,
    required this.price,
    this.images,
    this.vedioUrl,
    this.guarantee,
    this.propert,
    this.address,
    this.madeIn,
    this.year,
    this.quantity,
    this.gifUrl,
    this.discountPercentage,
    this.priceAfterDiscount,
    required this.country,
  });
  @override
  List<Object?> get props => [
        id,
        owner,
        name,
        imageUrl,
        category,
        condition,
        description,
        price,
        images,
        vedioUrl,
        guarantee,
        propert,
        madeIn,
        year,
        quantity,
        gifUrl,
        discountPercentage,
        priceAfterDiscount,
        country,
      ];
}
