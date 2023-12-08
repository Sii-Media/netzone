import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/data/models/departments/departments_categories/departments_categories_model.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';

part 'category_products_model.g.dart';

@JsonSerializable()
class CategoryProductsModel {
  @JsonKey(name: '_id')
  final String id;
  final UserInfoModel owner;
  final String name;
  final String imageUrl;
  final DepartmentsCategoryModel category;
  final String? condition;
  final String description;
  final double price;
  final double? weight;
  final num? quantity;
  final List<String>? images;
  final String? vedioUrl;
  final bool? guarantee;
  final String? propert;
  final String? address;

  final String? madeIn;
  final String? year;
  final String? gifUrl;

  final double? discountPercentage;
  final double? priceAfterDiscount;
  final String country;
  final String? color;
  final double? averageRating;
  final double? totalRatings;

  CategoryProductsModel({
    required this.id,
    required this.owner,
    required this.name,
    required this.imageUrl,
    required this.category,
    this.condition,
    required this.description,
    required this.price,
    required this.weight,
    this.quantity,
    this.images,
    this.vedioUrl,
    this.guarantee,
    this.propert,
    this.address,
    this.madeIn,
    this.year,
    this.gifUrl,
    this.discountPercentage,
    this.priceAfterDiscount,
    required this.country,
    this.color,
    this.averageRating,
    this.totalRatings,
  });

  factory CategoryProductsModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryProductsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryProductsModelToJson(this);
}

extension MapToDomain on CategoryProductsModel {
  CategoryProducts toDomain() => CategoryProducts(
        id: id,
        owner: owner.toDomain(),
        name: name,
        imageUrl: imageUrl,
        category: category.toDomain(),
        condition: condition,
        description: description,
        price: price,
        weight: weight,
        quantity: quantity,
        images: images,
        vedioUrl: vedioUrl,
        guarantee: guarantee,
        propert: propert,
        address: address,
        madeIn: madeIn,
        year: year,
        gifUrl: gifUrl,
        discountPercentage: discountPercentage,
        priceAfterDiscount: priceAfterDiscount,
        country: country,
        color: color,
        averageRating: averageRating,
        totalRatings: totalRatings,
      );
}
