import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/local_company/local_company_category.dart';
import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetLocalCompanyCategoriesUseCase
    extends UseCase<List<LocalCompanyCategory>, NoParams> {
  final LocalCompanyRepository localCompanyRepository;

  GetLocalCompanyCategoriesUseCase({required this.localCompanyRepository});

  @override
  Future<Either<Failure, List<LocalCompanyCategory>>> call(NoParams params) {
    return localCompanyRepository.getAllLocalCompanyCategories();
  }
}
