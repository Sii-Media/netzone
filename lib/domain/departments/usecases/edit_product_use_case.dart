import 'dart:io';

import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../repositories/departments_repository.dart';

class EditProductUseCase extends UseCase<String, EditProductParams> {
  final DepartmentRepository departmentRepository;

  EditProductUseCase({required this.departmentRepository});
  @override
  Future<Either<Failure, String>> call(EditProductParams params) {
    return departmentRepository.editProduct(
      productId: params.productId,
      name: params.name,
      description: params.description,
      price: params.price,
      quantity: params.quantity,
      weight: params.weight,
      image: params.image,
      video: params.video,
      guarantee: params.guarantee,
      address: params.address,
      madeIn: params.madeIn,
    );
  }
}

class EditProductParams {
  final String productId;
  final String name;
  final String description;
  final double price;
  final int? quantity;
  final double? weight;
  final File? image;
  final File? video;
  final bool? guarantee;
  final String? address;
  final String? madeIn;

  EditProductParams({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    this.quantity,
    this.weight,
    required this.guarantee,
    required this.address,
    required this.image,
    this.video,
    required this.madeIn,
  });
}
