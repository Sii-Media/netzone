import 'dart:io';

import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/deals/repositories/deals_repository.dart';

import '../../core/usecase/usecase.dart';

class AddDealUseCase extends UseCase<String, AddDealParams> {
  final DealsRepository dealsRepository;

  AddDealUseCase({required this.dealsRepository});
  @override
  Future<Either<Failure, String>> call(AddDealParams params) {
    return dealsRepository.addDeal(
      name: params.name,
      companyName: params.companyName,
      dealImage: params.dealImage,
      prevPrice: params.prevPrice,
      currentPrice: params.currentPrice,
      startDate: params.startDate,
      endDate: params.endDate,
      location: params.location,
      category: params.category,
    );
  }
}

class AddDealParams {
  final String name;
  final String companyName;
  final File dealImage;
  final int prevPrice;
  final int currentPrice;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String category;

  AddDealParams({
    required this.name,
    required this.companyName,
    required this.dealImage,
    required this.prevPrice,
    required this.currentPrice,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
  });
}
