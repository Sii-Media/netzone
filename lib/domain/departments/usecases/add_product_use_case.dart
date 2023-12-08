import 'dart:io';

import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/departments/repositories/departments_repository.dart';

class AddProductUseCase extends UseCase<String, AddProductParams> {
  final DepartmentRepository departmentRepository;

  AddProductUseCase({required this.departmentRepository});
  @override
  Future<Either<Failure, String>> call(AddProductParams params) {
    return departmentRepository.addProduct(
      departmentName: params.departmentName,
      categoryName: params.categoryName,
      name: params.name,
      description: params.description,
      price: params.price,
      weight: params.weight,
      guarantee: params.guarantee,
      image: params.image,
      images: params.images,
      madeIn: params.madeIn,
      property: params.property,
      videoUrl: params.videoUrl,
      country: params.country,
    );
  }
}

class AddProductParams {
  final String departmentName;
  final String categoryName;
  final String name;
  final String description;
  final double price;
  final double weight;
  final List<String>? images;
  final String? videoUrl;
  final String? guarantee;
  final String? property;
  final String? madeIn;
  final File image;
  final String country;

  AddProductParams({
    required this.departmentName,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.price,
    required this.weight,
    this.images,
    this.videoUrl,
    this.guarantee,
    this.property,
    this.madeIn,
    required this.image,
    required this.country,
  });
}
