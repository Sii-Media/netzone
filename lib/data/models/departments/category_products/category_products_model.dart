import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';

part 'category_products_model.g.dart';

@JsonSerializable()
class CategoryProductsModel {
  @JsonKey(name: '_id')
  final String? id;
  final String owner;
  final String name;
  final String imageUrl;
  final String category;
  final String description;
  final int price;
  final List<String>? images;
  final String? vedioUrl;
  final bool? guarantee;
  final String? propert;
  final String? madeIn;
  final String? year;

  CategoryProductsModel({
    this.id,
    required this.owner,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.price,
    this.images,
    this.vedioUrl,
    this.guarantee,
    this.propert,
    this.madeIn,
    this.year,
  });

  factory CategoryProductsModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryProductsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryProductsModelToJson(this);
}

extension MapToDomain on CategoryProductsModel {
  CategoryProducts toDomain() => CategoryProducts(
        id: id,
        owner: owner,
        name: name,
        imageUrl: imageUrl,
        category: category,
        description: description,
        price: price,
        images: images,
        vedioUrl: vedioUrl,
        guarantee: guarantee,
        propert: propert,
        madeIn: madeIn,
        year: year,
      );
}
