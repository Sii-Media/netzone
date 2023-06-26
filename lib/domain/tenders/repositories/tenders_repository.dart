import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/tenders/entities/tender_response.dart';
import 'package:netzoon/domain/tenders/entities/tendersItems/tenders_items_response.dart';

abstract class TenderRepository {
  Future<Either<Failure, TenderResponse>> getTendersCategories();

  Future<Either<Failure, TenderItemResponse>> getTendersItems();

  Future<Either<Failure, TenderItemResponse>> getTendersItemsByMin({
    required String category,
  });
  Future<Either<Failure, TenderItemResponse>> getTendersItemsByMax({
    required String category,
  });

  Future<Either<Failure, String>> addTender({
    required String nameAr,
    required String nameEn,
    required String companyName,
    required DateTime startDate,
    required DateTime endDate,
    required int price,
    required File tenderImage,
    required String category,
  });
}
