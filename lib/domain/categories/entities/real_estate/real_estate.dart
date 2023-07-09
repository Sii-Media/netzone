import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';

class RealEstate extends Equatable {
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
  final UserInfo createdBy;

  const RealEstate({
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
  });

  @override
  List<Object?> get props => [
        id,
        title,
        imageUrl,
        description,
        price,
        area,
        location,
        bedrooms,
        bathrooms,
        amenities,
        images,
        createdBy
      ];
}
