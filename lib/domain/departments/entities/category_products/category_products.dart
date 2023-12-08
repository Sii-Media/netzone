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
  final double price;
  final double? weight;
  final List<String>? images;
  final String? vedioUrl;
  final bool? guarantee;
  final String? propert;
  final String? address;
  final String? madeIn;
  final String? year;
  final num? quantity;
  final num? cartQty;
  final String? gifUrl;
  final double? discountPercentage;
  final double? priceAfterDiscount;
  final String country;
  final String? color;
  final double? averageRating;
  final double? totalRatings;

  const CategoryProducts({
    required this.id,
    required this.owner,
    required this.name,
    required this.imageUrl,
    required this.category,
    this.condition,
    required this.description,
    required this.price,
    required this.weight,
    this.images,
    this.vedioUrl,
    this.guarantee,
    this.propert,
    this.address,
    this.madeIn,
    this.year,
    this.quantity,
    this.cartQty,
    this.gifUrl,
    this.discountPercentage,
    this.priceAfterDiscount,
    required this.country,
    this.color,
    this.averageRating,
    this.totalRatings,
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
        weight,
        images,
        vedioUrl,
        guarantee,
        propert,
        madeIn,
        year,
        quantity,
        cartQty,
        gifUrl,
        discountPercentage,
        priceAfterDiscount,
        country,
        color,
      ];
}
