import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../repositories/deals_repository.dart';

class DeleteDealUseCase extends UseCase<String, String> {
  final DealsRepository dealsRepository;

  DeleteDealUseCase({required this.dealsRepository});

  @override
  Future<Either<Failure, String>> call(String params) {
    return dealsRepository.deleteDeal(id: params);
  }
}
