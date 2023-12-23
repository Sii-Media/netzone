import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/deals/entities/deals/deals_response.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items_response.dart';

import '../entities/dealsItems/deals_items.dart';

abstract class DealsRepository {
  Future<Either<Failure, DealsResponse>> getDealsCategories();
  Future<Either<Failure, DealsItemsResponse>> getDealsItems(
      {required String country});

  Future<Either<Failure, DealsItems>> getDealById({required String id});

  Future<Either<Failure, DealsItemsResponse>> getDealsByCategory({
    required final String category,
    required final String country,
    String? companyName,
    int? minPrice,
    int? maxPrice,
  });

  Future<Either<Failure, List<DealsItems>>> getUserDeals(
      {required String userId});

  Future<Either<Failure, String>> addDeal({
    required final String owner,
    required final String name,
    required final String companyName,
    required File dealImage,
    required final int prevPrice,
    required final int currentPrice,
    required final DateTime startDate,
    required final DateTime endDate,
    required final String location,
    required final String category,
    required final String country,
    required final String description,
  });

  Future<Either<Failure, String>> editDeal({
    required final String id,
    required final String name,
    required final String companyName,
    required File? dealImage,
    required final int prevPrice,
    required final int currentPrice,
    required final DateTime startDate,
    required final DateTime endDate,
    required final String location,
    required final String category,
    required final String country,
    required final String description,
  });
  Future<Either<Failure, String>> deleteDeal({
    required String id,
  });
}
