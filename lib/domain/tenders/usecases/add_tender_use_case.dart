import 'dart:io';

import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/tenders/repositories/tenders_repository.dart';

class AddTenderUseCase extends UseCase<String, AddTenderParams> {
  final TenderRepository tenderRepository;

  AddTenderUseCase({required this.tenderRepository});
  @override
  Future<Either<Failure, String>> call(AddTenderParams params) {
    return tenderRepository.addTender(
      nameAr: params.nameAr,
      nameEn: params.nameEn,
      companyName: params.companyName,
      startDate: params.startDate,
      endDate: params.endDate,
      price: params.price,
      tenderImage: params.tenderImage,
      category: params.category,
    );
  }
}

class AddTenderParams {
  final String nameAr;
  final String nameEn;
  final String companyName;
  final DateTime startDate;
  final DateTime endDate;
  final int price;
  final File tenderImage;
  final String category;

  AddTenderParams({
    required this.nameAr,
    required this.nameEn,
    required this.companyName,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.tenderImage,
    required this.category,
  });
}
