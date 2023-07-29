import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../../repositories/local_company_reponsitory.dart';

class DeleteCompanyServiceUseCase extends UseCase<String, String> {
  final LocalCompanyRepository localCompanyRepository;

  DeleteCompanyServiceUseCase({required this.localCompanyRepository});

  @override
  Future<Either<Failure, String>> call(String params) {
    return localCompanyRepository.deleteCompanyService(id: params);
  }
}
