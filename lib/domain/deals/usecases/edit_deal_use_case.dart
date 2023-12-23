import 'dart:io';

import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../repositories/deals_repository.dart';

class EditDealUseCase extends UseCase<String, EditDealParams> {
  final DealsRepository dealsRepository;

  EditDealUseCase({required this.dealsRepository});

  @override
  Future<Either<Failure, String>> call(EditDealParams params) {
    return dealsRepository.editDeal(
      id: params.id,
      name: params.name,
      companyName: params.companyName,
      dealImage: params.dealImage,
      prevPrice: params.prevPrice,
      currentPrice: params.currentPrice,
      startDate: params.startDate,
      endDate: params.endDate,
      location: params.location,
      category: params.category,
      country: params.country,
      description: params.description,
    );
  }
}

class EditDealParams {
  final String id;
  final String name;
  final String companyName;
  final File? dealImage;
  final int prevPrice;
  final int currentPrice;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String category;
  final String country;
  final String description;
  EditDealParams({
    required this.id,
    required this.name,
    required this.companyName,
    required this.dealImage,
    required this.prevPrice,
    required this.currentPrice,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    required this.country,
    required this.description,
  });
}
