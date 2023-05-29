import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/customs/customs_company.dart';
import 'package:netzoon/domain/categories/repositories/customs_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import '../../../core/usecase/usecase.dart';

class GetCustomCompaniesUseCase extends UseCase<CustomsCompanies, String> {
  final CustomsRepository customsRepository;

  GetCustomCompaniesUseCase({required this.customsRepository});
  @override
  Future<Either<Failure, CustomsCompanies>> call(String params) {
    return customsRepository.getCustomCompanies(id: params);
  }
}
