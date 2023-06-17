import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/deals/entities/deals/deals_response.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items_response.dart';

abstract class DealsRepository {
  Future<Either<Failure, DealsResponse>> getDealsCategories();
  Future<Either<Failure, DealsItemsResponse>> getDealsItems();
  Future<Either<Failure, DealsItemsResponse>> getDealsByCategory({
    required final String category,
  });

  Future<Either<Failure, String>> addDeal({
    required final String name,
    required final String companyName,
    required File dealImage,
    required final int prevPrice,
    required final int currentPrice,
    required final DateTime startDate,
    required final DateTime endDate,
    required final String location,
    required final String category,
  });
}
