import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';

class GetCompanyProductsUseCase
    extends UseCase<List<CategoryProducts>, String> {
  final LocalCompanyRepository localCompanyRepository;

  GetCompanyProductsUseCase({required this.localCompanyRepository});

  @override
  Future<Either<Failure, List<CategoryProducts>>> call(String params) {
    return localCompanyRepository.getCompanyProducts(id: params);
  }
}
