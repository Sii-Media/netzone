import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/departments/category_products/category_products_model.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products_response.dart';

part 'category_products_response_model.g.dart';

@JsonSerializable()
class CategoryProductsResponseModel {
  final String message;

  @JsonKey(name: 'results')
  final List<CategoryProductsModel> categoryProducts;

  CategoryProductsResponseModel({
    required this.message,
    required this.categoryProducts,
  });

  factory CategoryProductsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryProductsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryProductsResponseModelToJson(this);
}

extension MapToDomain on CategoryProductsResponseModel {
  CategoryProductsResponse toDomain() => CategoryProductsResponse(
        message: message,
        products: categoryProducts.map((e) => e.toDomain()).toList(),
      );
}
