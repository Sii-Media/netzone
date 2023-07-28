import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../../repositories/local_company_reponsitory.dart';

class RateCompanyServiceUseCase
    extends UseCase<String, RateCompanyServiceParams> {
  final LocalCompanyRepository localCompanyRepository;

  RateCompanyServiceUseCase({required this.localCompanyRepository});

  @override
  Future<Either<Failure, String>> call(RateCompanyServiceParams params) {
    return localCompanyRepository.rateCompanyService(
        id: params.id, rating: params.rating, userId: params.userId);
  }
}

class RateCompanyServiceParams {
  final String id;
  final double rating;
  final String userId;

  RateCompanyServiceParams(
      {required this.id, required this.rating, required this.userId});
}
