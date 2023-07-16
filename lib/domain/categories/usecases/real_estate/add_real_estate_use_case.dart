import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/real_estate_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:share_plus/share_plus.dart';

class AddRealEstateUseCase extends UseCase<String, AddRealEstateParams> {
  final RealEstateRepository realEstateRepository;

  AddRealEstateUseCase({required this.realEstateRepository});
  @override
  Future<Either<Failure, String>> call(AddRealEstateParams params) {
    return realEstateRepository.addRealEstate(
      createdBy: params.createdBy,
      title: params.title,
      image: params.image,
      description: params.description,
      price: params.price,
      area: params.area,
      location: params.location,
      bedrooms: params.bedrooms,
      bathrooms: params.bathrooms,
      amenities: params.amenities,
      realestateimages: params.realestateimages,
      country: params.country,
    );
  }
}

class AddRealEstateParams {
  final String createdBy;
  final String title;
  final File image;
  final String description;
  final int price;
  final int area;
  final String location;
  final int bedrooms;
  final int bathrooms;
  final List<String>? amenities;
  final List<XFile>? realestateimages;
  final String country;
  AddRealEstateParams({
    required this.createdBy,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.area,
    required this.location,
    required this.bedrooms,
    required this.bathrooms,
    this.amenities,
    this.realestateimages,
    required this.country,
  });
}
