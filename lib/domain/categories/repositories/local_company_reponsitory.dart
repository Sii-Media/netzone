import 'package:dartz/dartz.dart';
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
    required int price,
    required String owner,
  });
}
