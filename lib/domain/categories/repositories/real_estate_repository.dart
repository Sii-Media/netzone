import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/categories/entities/real_estate/real_estate.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:share_plus/share_plus.dart';

abstract class RealEstateRepository {
  Future<Either<Failure, List<RealEstate>>> getAllRealEstates({
    required String country,
  });
  Future<Either<Failure, List<UserInfo>>> getRealEstateCompanies({
    required String country,
  });
  Future<Either<Failure, List<RealEstate>>> getcompanyRealEstates({
    required String id,
  });
  Future<Either<Failure, String>> addRealEstate({
    required String createdBy,
    required String title,
    required File image,
    required String description,
    required int price,
    required int area,
    required String location,
    required int bedrooms,
    required int bathrooms,
    List<String>? amenities,
    List<XFile>? realestateimages,
    required String country,
  });
}
