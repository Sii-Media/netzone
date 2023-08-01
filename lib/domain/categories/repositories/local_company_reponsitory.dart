import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/domain/categories/entities/local_company/local_company.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';

import '../../auth/entities/user_info.dart';
import '../../company_service/company_service.dart';

abstract class LocalCompanyRepository {
  Future<Either<Failure, List<LocalCompany>>> getAllLocalCompany();
  Future<Either<Failure, List<CategoryProducts>>> getCompanyProducts({
    required String id,
  });

  Future<Either<Failure, List<UserInfo>>> getLocalCompanies({
    required String country,
    required String userType,
  });

  Future<Either<Failure, List<CompanyService>>> getCompanyServices({
    required String id,
  });

  Future<Either<Failure, String>> addCompanyService({
    required String title,
    required String description,
    int? price,
    required String owner,
    File? image,
    List<XFile>? serviceImageList,
    String? whatsAppNumber,
  });
  Future<Either<Failure, String>> rateCompanyService({
    required String id,
    required double rating,
    required String userId,
  });

  Future<Either<Failure, String>> editCompanyService({
    required String id,
    required String title,
    required String description,
    int? price,
    File? image,
    required List<File?> serviceImageList,
    String? whatsAppNumber,
  });
  Future<Either<Failure, String>> deleteCompanyService({
    required String id,
  });
}
