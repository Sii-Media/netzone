import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/categories/entities/real_estate/real_estate.dart';

import '../auth/user_info/user_info_model.dart';

part 'real_estate_model.g.dart';

@JsonSerializable()
class RealEstateModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  final double area;
  final String location;
  final int bedrooms;
  final int bathrooms;
  final List<String>? amenities;
  final List<String>? images;
  final UserInfoModel createdBy;
  final String country;
  final String? type;
  final String? category;
  final String? forWhat;
  final bool? furnishing;
  RealEstateModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.area,
    required this.location,
    required this.bedrooms,
    required this.bathrooms,
    this.amenities,
    this.images,
    required this.createdBy,
    required this.country,
    this.type,
    this.category,
    this.forWhat,
    this.furnishing,
  });

  factory RealEstateModel.fromJson(Map<String, dynamic> json) =>
      _$RealEstateModelFromJson(json);

  Map<String, dynamic> toJson() => _$RealEstateModelToJson(this);
}

extension MapToDomain on RealEstateModel {
  RealEstate toDomain() => RealEstate(
        id: id,
        title: title,
        imageUrl: imageUrl,
        description: description,
        price: price,
        area: area,
        location: location,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        createdBy: createdBy.toDomain(),
        amenities: amenities,
        images: images,
        country: country,
        type: type,
        category: category,
        forWhat: forWhat,
        furnishing: furnishing,
      );
}
